Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FADB7F66
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 14:47:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80059304053
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 12:47:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id i96FtpDOk3jA48VT for
	<xfs@oss.sgi.com>; Mon, 28 Jan 2013 12:47:46 -0800 (PST)
Message-ID: <5106E3EE.2030601@redhat.com>
Date: Mon, 28 Jan 2013 14:47:42 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2 V2] xfs_logprint: Handle multiply-logged inode fields
References: <5092A1DE.10609@redhat.com> <5092A2B6.2000907@redhat.com>
	<5092A46A.8080909@sandeen.net> <20130122175530.GR27055@sgi.com>
	<20130122210511.GK2498@dastard>
In-Reply-To: <20130122210511.GK2498@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 1/22/13 3:05 PM, Dave Chinner wrote:
> On Tue, Jan 22, 2013 at 11:55:30AM -0600, Ben Myers wrote:
>> Hey Eric,
>>
>> On Thu, Nov 01, 2012 at 11:33:46AM -0500, Eric Sandeen wrote:
>>> As xlog_print_trans_inode() stands today, it will error
>>> out if more than one flag is set on f->ilf_fields:
>>>
>>> 	xlog_print_trans_inode: illegal inode type
>>>
>>> but this is a perfectly valid case, to have i.e. a data and
>>> an attr flag set.
>>>
>>> Following is a pretty big reworking of the function to
>>> handle more than one field type set.
>>
>> I'm trying to wrap my head around this one.  I have a few stupid questions.
>>
>>> I've tested this by a simple test such as creating one
>>> file on an selinux box, so that data+attr is set, and
>>> logprinting; I've also tested by running logprint after
>>> subsequent xfstest runs (although we hit other bugs that
>>> way).
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> V2: Fix subject, sigh.
>>>
>>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>>> index e42e108..be2426e 100644
>>> --- a/logprint/log_misc.c
>>> +++ b/logprint/log_misc.c
>>> @@ -657,97 +657,84 @@ xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops)
>>>  
>>>      /* does anything come next */
>>>      op_head = (xlog_op_header_t *)*ptr;
>>> -    switch (f->ilf_fields & XFS_ILOG_NONCORE) {
>>> -	case XFS_ILOG_DEXT: {
>>> -	    ASSERT(f->ilf_size == 3);
>>> -	    (*i)++;
>>> -	    xlog_print_op_header(op_head, *i, ptr);
>>> -	    printf(_("EXTENTS inode data\n"));
>>> -	    *ptr += be32_to_cpu(op_head->oh_len);
>>> -	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))  {
>>> -		return 1;
>>> -	    }
>>> -	    break;
>>> -	}
>>> -	case XFS_ILOG_DBROOT: {
>>> -	    ASSERT(f->ilf_size == 3);
>>> -	    (*i)++;
>>> -	    xlog_print_op_header(op_head, *i, ptr);
>>> -	    printf(_("BTREE inode data\n"));
>>> -	    *ptr += be32_to_cpu(op_head->oh_len);
>>> -	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))  {
>>> -		return 1;
>>> -	    }
>>> +
>>> +    if (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
>>> +	switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
>>
>> Here you kept only XFS_ILOG_DEV and XFS_ILOG_UUID...
>>
>>> +	case XFS_ILOG_DEV:
>>> +	    printf(_("DEV inode: no extra region\n"));
>>>  	    break;
>>> -	}
>>> -	case XFS_ILOG_DDATA: {
>>> -	    ASSERT(f->ilf_size == 3);
>>> -	    (*i)++;
>>> -	    xlog_print_op_header(op_head, *i, ptr);
>>> -	    printf(_("LOCAL inode data\n"));
>>> -	    if (mode == S_IFDIR) {
>>> -		xlog_print_dir_sf((xfs_dir_shortform_t*)*ptr, size);
>>> -	    }
>>> -	    *ptr += be32_to_cpu(op_head->oh_len);
>>> -	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS)) {
>>> -		return 1;
>>> -	    }
>>> +	case XFS_ILOG_UUID:
>>> +	    printf(_("UUID inode: no extra region\n"));
>>>  	    break;
>>> +	case XFS_ILOG_DEXT:
>>> +	case XFS_ILOG_DBROOT:
>>> +	case XFS_ILOG_DDATA:
>>
>> Do you need to test for these other flags here?
> 
> It's defensive code - ensuring that they never overlap as the fields
> are mutually exclusive. i.e if XFS_ILOG_DEV or XFS_ILOG_UUID is
> set, the data fork format flags should not be set as the other two
> fields indicate the data fork contents....
> 
>>> +	default:
>>> +	    xlog_panic(_("xlog_print_trans_inode: illegal inode type 0x%x"),
>>> +			f->ilf_fields);
>>>  	}
>>> -	case XFS_ILOG_AEXT: {
>>> -	    ASSERT(f->ilf_size == 3);
>>> +    }
>>> +
>>> +    if (f->ilf_fields & (XFS_ILOG_DFORK | XFS_ILOG_AFORK)) {
>>> +	ASSERT(f->ilf_size <= 4);
>>
>> Can you explain this ASSERT?  I saw only ilf_size == 3 in the old code.  Under
>> what circumstances can it be 4?  Maybe when multiple ilf_fields are set?
> 
> XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP | XFS_ILOG_DFORK | XFS_ILOG_AFORK
> 
>>> +	ASSERT((f->ilf_size == 3) || (f->ilf_fields & XFS_ILOG_AFORK));
>>
>> I also don't understand this ASSERT.  It seems like in the old code all of the
>> AFORK related cases had an ASSERT for ilf_size == 3.
> 
> It's valid - if the size is not 3, the the attribute for must be
> logged - it's the only way to get 4 format items.
> 
>>
>>> +	if (f->ilf_fields & XFS_ILOG_DFORK) {
>>>  	    (*i)++;
>>>  	    xlog_print_op_header(op_head, *i, ptr);
>>> -	    printf(_("EXTENTS inode attr\n"));
>>> -	    *ptr += be32_to_cpu(op_head->oh_len);
>>> -	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))  {
>>> -		return 1;
>>> +
>>> +	    switch (f->ilf_fields & XFS_ILOG_DFORK) {
>>> +	    case XFS_ILOG_DEXT:
>>> +		printf(_("EXTENTS inode data\n"));
>>> +		break;
>>> +	    case XFS_ILOG_DBROOT:
>>> +		printf(_("BTREE inode data\n"));
>>> +		break;
>>> +	    case XFS_ILOG_DDATA:
>>> +		printf(_("LOCAL inode data\n"));
>>> +		if (mode == S_IFDIR)
>>> +		    xlog_print_dir_sf((xfs_dir_shortform_t*)*ptr, size);
>>> +		break;
>>> +	    case XFS_ILOG_DEV:
>>> +	    case XFS_ILOG_UUID:
>>
>> ILOG_DEV and ILOG_UUID aren't in ILOG_DFORK.  You needn't test for them, correct?
> 
> See above.
> 
> Cheers,
> 
> Dave.
> 

Ben, Mark -

Where are we at with this one?  We have a partner who is interested in the fix.
Do you want anything more from me before it can be merged?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
