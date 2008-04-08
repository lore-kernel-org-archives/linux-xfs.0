Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 00:47:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m387l5g2007708
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 00:47:11 -0700
Date: Tue, 08 Apr 2008 17:48:58 +1000
Subject: Re: [REVIEW] cleanup - remove bhv_vname_t
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t89zp3j63jf8g2@pc-bnaujok.melbourne.sgi.com> <20080408063822.GA21876@infradead.org> <op.t895ac193jf8g2@pc-bnaujok.melbourne.sgi.com> <20080408074106.GA3207@infradead.org>
Message-ID: <op.t897zwgr3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080408074106.GA3207@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, 08 Apr 2008 17:41:06 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Tue, Apr 08, 2008 at 04:50:26PM +1000, Barry Naujok wrote:
>>>> +static inline struct xfs_name *
>>>> +xfs_dentry_name(
>>>> +	struct xfs_name	*namep,
>>>> +	struct dentry	*dentry)
>>>> +{
>>>> +	namep->name = dentry->d_name.name;
>>>> +	namep->len = dentry->d_name.len;
>>>> +	return namep;
>>>> +}
>>>
>>> As mentioned in my comment to the CI series:  shouldn't you just use
>>> a struct qstr instead of adding a new struct xfs_name?
>>
>> Keeping a clean line between fs/xfs and fs/xfs/linux-2.6.
>
> But this means more stack useage and more copies in every namespace
> related operation.  I don'y yhink it's a good tradeoff.

This will happen anyway for Unicode NLS support. Also, this patch
doesn't increase stack usage anywhere and some have reduced stack usage.

> If you really care about a clear separatation add a #define or typedef
> for xfs_name to struct qstr.

and qstr is platform dependant (yes, I know you said it's premature!)

Barry.
