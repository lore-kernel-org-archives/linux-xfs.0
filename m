Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 18:46:31 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBJ2kOO6015690
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 18:46:26 -0800
Received: from hs-out-2122.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 021ED49BDD4
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 18:46:32 -0800 (PST)
Received: from hs-out-2122.google.com (hs-out-0708.google.com [64.233.178.247]) by cuda.sgi.com with ESMTP id Z6ziMsoRBd2K8o3E for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 18:46:32 -0800 (PST)
Received: by hs-out-2122.google.com with SMTP id m63so630914hsc.4
        for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 18:46:30 -0800 (PST)
Message-ID: <dda83e780712181846w5549fe0bs7589d67b9d86c666@mail.gmail.com>
Date: Tue, 18 Dec 2007 18:46:30 -0800
From: "Bret Towe" <magnade@gmail.com>
Subject: Re: xfs mknod regression
In-Reply-To: <20071218173642.GA7338@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
	 <20071218173642.GA7338@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Dec 18, 2007 9:36 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
> which assigned the re-shuffled ondisk dev_t back to the rdev variable in
> xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
> of the linux dev_t later down the function.
>
> Fortunately the fix for it is trivial:  we can just remove the
> assignment because xfs_revalidate_inode has done the proper job before
> unlocking the inode.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

tested the patch on 2 machines and works fine for me

Thanks
