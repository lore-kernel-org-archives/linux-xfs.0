Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9GFFndM153701 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 10:15:49 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id c7JUmiFrauPAsd2l for
	<xfs@oss.sgi.com>; Tue, 16 Oct 2012 08:17:11 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9GFH9HK013913
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 11:17:10 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q9GFH8T6013045
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 11:17:09 -0400
Message-ID: <507D7AC8.2030704@redhat.com>
Date: Tue, 16 Oct 2012 11:18:32 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH] xfs: enables file data inlining in inodes
References: <1349985158-9952-1-git-send-email-cmaiolino@redhat.com>
	<507837E6.4040807@redhat.com>
	<20121015171904.GB8376@andromeda.usersys.redhat.com>
	<507C5648.3020306@redhat.com>
	<20121016144829.GA8752@andromeda.usersys.redhat.com>
In-Reply-To: <20121016144829.GA8752@andromeda.usersys.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 10/16/2012 10:48 AM, Carlos Maiolino wrote:
> On Mon, Oct 15, 2012 at 02:30:32PM -0400, Brian Foster wrote:
>> On 10/15/2012 01:19 PM, Carlos Maiolino wrote:
>>> On Fri, Oct 12, 2012 at 11:31:50AM -0400, Brian Foster wrote:
>>>> On 10/11/2012 03:52 PM, Carlos Maiolino wrote:
>>>>> Hi,
>>>>>
...
>> I'm not quite sure I follow what you mean by catching file changes, so I
>> certainly could be missing something... 
> 
> An example: If you extend a file, you need to check if the file still fits in
> the inode. I'm not sure that only i_size_read(inode) will check for this, that's
> why I added end_offset + i_size_read(), but, I believe it's wrong (end_offset +
> i_size_read).
> 

FWIW, there is an i_size_write() in generic_write_end() (via
xfs_vm_write_end()) that looks like it handles the file extension case.

>> but it seems like the code
>> earlier in xfs_vm_writepage() already handles the truncate case. If the
>> file size increased in that time, would this code really care? Wouldn't
>> that mean you'd have to convert the file at that point, presumably when
>> you get a writepage on one of the pages that falls outside the available
>> space?
>>
>> Perhaps this gets more into detection of the current inode format when
>> you have to convert back and forth and this logic naturally becomes more
>> complicated (and thus I'm just reading too far ahead :P).
>>
> Yes, as the patch description says, it doesn't care about file conversion yet :)
> this only cares about write/read new files into inodes, I want to make sure I'm
> doing this part properly, before move on the the next step, which is take care
> of these conversions, if I take care of everything at the same time I'll get
> crazy and have nothing done at the same time :-)
> 

I hear you. ;)

Brian

>> Brian
>>
>>>
>>>> Brian
>>>>
>>>>> +		err = xfs_inline_write(ip, page, bh, end_offset);
>>>>> +
>>>>> +		if (err)
>>>>> +			goto error;
>>>>> +		return 0;
>>>>> +	}
>>>>> +
>>>>>  	offset = page_offset(page);
>>>>>  	type = XFS_IO_OVERWRITE;
>>>>>  
>>>>> @@ -1624,20 +1723,43 @@ xfs_vm_bmap(
>>>>>  
>>>>>  STATIC int
>>>>>  xfs_vm_readpage(
>>>>> -	struct file		*unused,
>>>>> +	struct file		*filp,
>>>>>  	struct page		*page)
>>>>>  {
>>>>> -	return mpage_readpage(page, xfs_get_blocks);
>>>>> +	struct inode		*inode = filp->f_mapping->host;
>>>>> +	struct xfs_inode	*ip = XFS_I(inode);
>>>>> +
>>>>> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>>>>> +		return xfs_inline_read(ip, page, page->mapping);
>>>>> +	else
>>>>> +		return mpage_readpage(page, xfs_get_blocks);
>>>>>  }
>>>>>  
>>>>>  STATIC int
>>>>>  xfs_vm_readpages(
>>>>> -	struct file		*unused,
>>>>> +	struct file		*filp,
>>>>>  	struct address_space	*mapping,
>>>>>  	struct list_head	*pages,
>>>>>  	unsigned		nr_pages)
>>>>>  {
>>>>> -	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
>>>>> +	struct inode		*inode = filp->f_mapping->host;
>>>>> +	struct xfs_inode	*ip = XFS_I(inode);
>>>>> +
>>>>> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
>>>>> +		struct page	*page = list_first_entry(pages, struct page, lru);
>>>>> +
>>>>> +		ASSERT(i_size_read(VFS_I(ip) <= PAGE_CACHE_SIZE));
>>>>> +
>>>>> +		list_del(&page->lru);
>>>>> +		if(!(add_to_page_cache_lru(page, mapping,
>>>>> +					    page->index, GFP_KERNEL)))
>>>>> +			return xfs_inline_read(ip, page, page->mapping);
>>>>> +
>>>>> +		page_cache_release(page);
>>>>> +		return 0;
>>>>> +	} else {
>>>>> +		return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
>>>>> +	}
>>>>>  }
>>>>>  
>>>>>  const struct address_space_operations xfs_address_space_operations = {
>>>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>>>> index 2778258..5e56e5c 100644
>>>>> --- a/fs/xfs/xfs_inode.c
>>>>> +++ b/fs/xfs/xfs_inode.c
>>>>> @@ -287,18 +287,6 @@ xfs_iformat(
>>>>>  	case S_IFDIR:
>>>>>  		switch (dip->di_format) {
>>>>>  		case XFS_DINODE_FMT_LOCAL:
>>>>> -			/*
>>>>> -			 * no local regular files yet
>>>>> -			 */
>>>>> -			if (unlikely(S_ISREG(be16_to_cpu(dip->di_mode)))) {
>>>>> -				xfs_warn(ip->i_mount,
>>>>> -			"corrupt inode %Lu (local format for regular file).",
>>>>> -					(unsigned long long) ip->i_ino);
>>>>> -				XFS_CORRUPTION_ERROR("xfs_iformat(4)",
>>>>> -						     XFS_ERRLEVEL_LOW,
>>>>> -						     ip->i_mount, dip);
>>>>> -				return XFS_ERROR(EFSCORRUPTED);
>>>>> -			}
>>>>>  
>>>>>  			di_size = be64_to_cpu(dip->di_size);
>>>>>  			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
>>>>> @@ -2471,7 +2459,8 @@ xfs_iflush_int(
>>>>>  	if (S_ISREG(ip->i_d.di_mode)) {
>>>>>  		if (XFS_TEST_ERROR(
>>>>>  		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
>>>>> -		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
>>>>> +		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
>>>>> +		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
>>>>>  		    mp, XFS_ERRTAG_IFLUSH_3, XFS_RANDOM_IFLUSH_3)) {
>>>>>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>>>>>  				"%s: Bad regular inode %Lu, ptr 0x%p",
>>>>>
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
