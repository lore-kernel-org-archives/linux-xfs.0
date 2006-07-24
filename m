Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 04:50:13 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6OBo1DW019018
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 04:50:02 -0700
Received: by nf-out-0910.google.com with SMTP id a27so1492641nfc
        for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 04:49:37 -0700 (PDT)
Message-ID: <68559cef0607240449m5005231t78f05673bb8309e2@mail.gmail.com>
Date: Mon, 24 Jul 2006 13:49:37 +0200
From: "Luca Maranzano" <liuk001@gmail.com>
Subject: Re: Page allocation failure writing to an XFS volume via NFS on CentOS 4.3
In-Reply-To: <20060721161326.GE12347@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68559cef0607210519q9f382c6n7104bef9cf9716f3@mail.gmail.com>
	 <20060721161326.GE12347@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Could it be an issue about the min_free_kbytes kernel parameter?

On my server its current value is 957, but I've read that this could
lead to kernel memory allocation failure even if there is actually
enough RAM available.

Since my trouble seem to be correlated to NFS access, could it be an
interaction between network and disk I/O to trigger this problem?

Thanks again.
Regards,
Luca


On 7/21/06, Chris Wedgwood <cw@f00f.org> wrote:
> On Fri, Jul 21, 2006 at 02:19:34PM +0200, Luca Maranzano wrote:
>
> > kswapd0: page allocation failure. order:0, mode:0xd0
>
> you're out of memory, see what's being so piggy
>
