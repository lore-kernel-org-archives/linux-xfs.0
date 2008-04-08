Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 00:41:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m387f35k006545
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 00:41:03 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 486DD75E889
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2008 00:41:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id cS0hW3hPsBK32qOX for <xfs@oss.sgi.com>; Tue, 08 Apr 2008 00:41:37 -0700 (PDT)
Date: Tue, 8 Apr 2008 03:41:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] cleanup - remove bhv_vname_t
Message-ID: <20080408074106.GA3207@infradead.org>
References: <op.t89zp3j63jf8g2@pc-bnaujok.melbourne.sgi.com> <20080408063822.GA21876@infradead.org> <op.t895ac193jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t895ac193jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Apr 08, 2008 at 04:50:26PM +1000, Barry Naujok wrote:
>>> +static inline struct xfs_name *
>>> +xfs_dentry_name(
>>> +	struct xfs_name	*namep,
>>> +	struct dentry	*dentry)
>>> +{
>>> +	namep->name = dentry->d_name.name;
>>> +	namep->len = dentry->d_name.len;
>>> +	return namep;
>>> +}
>>
>> As mentioned in my comment to the CI series:  shouldn't you just use
>> a struct qstr instead of adding a new struct xfs_name?
>
> Keeping a clean line between fs/xfs and fs/xfs/linux-2.6.

But this means more stack useage and more copies in every namespace
related operation.  I don'y yhink it's a good tradeoff.

If you really care about a clear separatation add a #define or typedef
for xfs_name to struct qstr.

>> Also please don't add inline for this.
>>> +xfs_name_t xfs_name_dotdot = {"..", 2};
>>
>> const?
>
> I should change all calls using xfs_name to use const xfs_name?

I just mean this global variable should be declared const.  Then
again all the xfs_name arguments are immutable, so it might be worth
marking them const.
