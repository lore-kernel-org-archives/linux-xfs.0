Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:50668 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbdBNHvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 02:51:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1487008001.3125.41.camel@HansenPartnership.com>
        <20170213194337.GA9852@infradead.org> <20170213213416.GA15349@dastard>
        <20170214060809.GA21114@infradead.org>
        <1487053651.3125.72.camel@HansenPartnership.com>
        <1487053720.3125.73.camel@HansenPartnership.com>
Date: Tue, 14 Feb 2017 20:46:32 +1300
In-Reply-To: <1487053720.3125.73.camel@HansenPartnership.com> (James
        Bottomley's message of "Mon, 13 Feb 2017 22:28:40 -0800")
Message-ID: <87lgt9mcyv.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [PATCH 1/2] fs: add inode helpers for fsuid and fsgid
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> Now that we have two different views of filesystem ids (the filesystem
> view and the kernel view), we have a problem in that
> current_fsuid/fsgid() return the kernel view but are sometimes used in
> filesystem code where the filesystem view shoud be used.  This patch
> introduces helpers to produce the filesystem view of current fsuid and
> fsgid.

If I am reading this right what we are seeing is that xfs explicitly
opted out of type safety with predictable results.   Accidentally
confusing kuids and uids, which is potentially security issue.

All of that said where are you getting sb->s_user_ns != &init_user_ns
for an xfs filesystem?  There are quite a few xfs interfaces that are
not ready for that.   xfs has a very wide userspace interface of ioctls
that all needs to be looked at and addressed carefully if there is
anything like this going on.

I think we really need to ask if we should use kuids and kgids for the
xfs internal quota code.  At the end of the day that is going to be
a whole lot less error prone.

> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index f0e70a1..18e9c41 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -399,4 +399,9 @@ do {						\
>  	*(_fsgid) = __cred->fsgid;		\
>  } while(0)
>  
> +/* return the current id in the filesystem view */
> +#define i_fsuid(i) from_kuid((i)->i_sb->s_user_ns, current_fsuid())
> +#define i_fsgid(i) from_kgid((i)->i_sb->s_user_ns, current_fsgid())

Could we please place these helpers in fs.h?
That should allow them to become inline functions and live with the
existing filesystem helpers in there.

My gut says the names disk_fsuid(i) and disk_fsgid(i) would be clearer.

Of course all of this has the challenge of error handling in the case
when current_fsuid or current_fsgid do not map into the current
filesystem.

Eric
