Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39282 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdEBPRS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 May 2017 11:17:18 -0400
Date: Tue, 2 May 2017 17:17:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
Message-ID: <20170502151717.GB22963@lst.de>
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com> <20170502073019.GD11582@lst.de> <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com> <20170502141751.GA21564@lst.de> <CAOQ4uxgO64HhFq-xYOY4r1ob_qH1BQbkHyzBSpwmv0WPxX7A1Q@mail.gmail.com> <20170502144730.GA22578@lst.de> <CAJfpegsZYUHXpzKX+j=-fFzxDPu5jMH=V8MNOOKtRiu5m0Haig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsZYUHXpzKX+j=-fFzxDPu5jMH=V8MNOOKtRiu5m0Haig@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, May 02, 2017 at 05:08:26PM +0200, Miklos Szeredi wrote:
> Two separate issues:
> 
>  a) is s_uuid unique across all currently mounted filesystems on this system
>  b) is s_uuid unique for all different filesystems that have been
> mounted at one time on some system
> 
> We can check (a) but not (b).  But failing (b) could have equally bad
> consequences as failing (a).

While (b) is harmful it's not anywhere near as harmful as (a).  And
while we can trivially protect against (a) protecting against the full
scope of (b) (e.g. including reboots) would be very hard.
