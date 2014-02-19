Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8FDCB7FF7
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 16:56:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 075CEAC003
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 14:56:25 -0800 (PST)
Received: from mail-qa0-f50.google.com (mail-qa0-f50.google.com
	[209.85.216.50]) by cuda.sgi.com with ESMTP id wJeQdQOqdGA670lg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 19 Feb 2014 14:56:21 -0800 (PST)
Received: by mail-qa0-f50.google.com with SMTP id cm18so1683492qab.37
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 14:56:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140219215805.GA1714@gmail.com>
References: <1392741489-20097-1-git-send-email-linkinjeon@gmail.com>
	<20140219215805.GA1714@gmail.com>
Date: Thu, 20 Feb 2014 07:56:21 +0900
Message-ID: <CAKYAXd_OhFBAt39Wf5XnOY4VhcNtQPCEV-OMYQcUd8j+LbF=9g@mail.gmail.com>
Subject: Re: [PATCH v5 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, Ashish Sangwan <a.sangwan@samsung.com>, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

2014-02-20 6:58 GMT+09:00, Dongsu Park <dongsu.park@profitbricks.com>:
> Hi Namjae,
> see below:
Hi Dongsu.
>
> On 19.02.2014 01:38, Namjae Jeon wrote:
>> This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for Ext4.
> ...<snip>...
>> +	/*
>> +	 * Don't start shifting extents until we make sure the hole is big
>> +	 * enough to accomodate the shift.
>> +	 */
>> +	path = ext4_ext_find_extent(inode, start - 1, NULL, 0);
>> +	depth = path->p_depth;
>> +	extent =  path[depth].p_ext;
>> +	ex_start = extent->ee_block;
>> +	ex_end = extent->ee_block + ext4_ext_get_actual_len(extent);
>> +	ext4_ext_drop_refs(path);
>> +	kfree(path);
>> +
>> +	if ((start == ex_start && shift > ex_start) ||
>> +	    (shift > start - ex_end)) {
>
> This line causes a compile error. So the fix would be like that:
Oops.. I made a stupid mistake when creating the patch at dawn..
Thanks for your pointing.
>
> -	    (shift > start - ex_end)) {
> +	    (shift > start - ex_end))
>
>> +		return -EINVAL;
>> +
>> +	/* Its safe to start updating extents */
Yes, Right.
> ...<snip>...
>
> Apart from that, the whole patchset seems to work without error,
> both on xfs and on ext4.
> Of course I had to remove Lukas' patches before testing collapse-range.
> So it would be excellent if two patch series could get somehow merged.
>
> Tested-by: Dongsu Park <dongsu.park@profitbricks.com>
Thank you so much for your testing!
>
> Regards,
> Dongsu
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
