Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 08:46:29 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KFkIDW020142
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 08:46:18 -0700
Received: by nf-out-0910.google.com with SMTP id a27so487136nfc
        for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 08:45:55 -0700 (PDT)
Message-ID: <cfac95650607200743if7190y7164089ebb1e389e@mail.gmail.com>
Date: Thu, 20 Jul 2006 15:43:28 +0100
From: "Roger Willcocks" <willcor@gmail.com>
Subject: Re: xfs_force_shutdown on full filesystem
In-Reply-To: <cfac95650602271135v2ee8b2aap8c87ae18bd4f1321@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfac95650602251509i7da3a41ew4972479e7cb6b409@mail.gmail.com>
	 <4401039B.9050700@sgi.com>
	 <cfac95650602270633k10f5fa94q6cf055398ffcc1c4@mail.gmail.com>
	 <cfac95650602271135v2ee8b2aap8c87ae18bd4f1321@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On 2/27/06, Roger Willcocks <willcor@gmail.com> wrote:
> On 2/27/06, Roger Willcocks <willcor@gmail.com> wrote:
>
> > I've reproduced the problem on a clean checkout of linux-2.6-xfs from
> > oss.sgi.com.
>
> I've narrowed this down to XFS_DIR_CREATENAME returning ENOSPC in
> xfs_create. (resblks = 40, resblks - XFS_IALLOC_SPACE_RES(mp) = 35).

For what it's worth, this eventually turned out to be a code
generation error. Updating the compiler made the problem go away.

--
Roger
