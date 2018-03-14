Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36484 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752205AbeCNPq4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:46:56 -0400
Date: Wed, 14 Mar 2018 16:46:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable
        inode
Message-ID: <20180314154655.GA4937@lst.de>
References: <CAOQ4uxjn8UN2-Hzr8u404ydKf8s41yVpMA93-n7r6Dr2VBz3dA@mail.gmail.com> <CAOQ4uxhdkhZup=ndukKCRtU13YVs8jQxT0zgOT_XN3_-tB8TfQ@mail.gmail.com> <CAOQ4uxhCjBA99X_C-GpEBf=jC4S_wSrxMwS6Ovj7BtWLK1GmUA@mail.gmail.com> <20180313131109.GB6260@lst.de> <CAOQ4uxiDHSC19-fRdZmXM5BJB3-p9_LdPgSmxpjGrdCzhV2W2Q@mail.gmail.com> <20180313215028.GE18129@dastard> <CAOQ4uxgsMwtQRCkpJTJoVO-mbU1yRz7F0pMOAVcJphEEKq8SHA@mail.gmail.com> <20180314123314.GG18129@dastard> <20180314124913.GA936@lst.de> <CAOQ4uxi0j=S+6zZo8YSzJQ4aSjdK02U2zxuOue7W3NtCrcKmSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi0j=S+6zZo8YSzJQ4aSjdK02U2zxuOue7W3NtCrcKmSQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>

On Wed, Mar 14, 2018 at 05:45:40PM +0200, Amir Goldstein wrote:
> I also read between the lines that the responsibility of herding the stable
> patches has shifted from you to Darrick in the last development cycle.

I have no idea if anyone is taking care of the stable tree at the moment,
maybe we'll need a volunteer..
