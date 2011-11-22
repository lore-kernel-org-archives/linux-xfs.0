Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMMGBx5174819
	for <linux-xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:16:12 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58C8B26F513
	for <linux-xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:16:10 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qKgM9lno1o4WaNaM for <linux-xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 14:16:10 -0800 (PST)
Date: Tue, 22 Nov 2011 17:16:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: stale NFS file handle problem on XFS inode64
Message-ID: <20111122221609.GB29540@infradead.org>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121170459.GA1327@infradead.org>
	<CAJNJY8Ty+bQpzGL9wq7Qv3ozcKUPwmTyYUeb2wQqZ326K4JeWw@mail.gmail.com>
	<20111122014609.GK2386@dastard>
	<CAJNJY8S2FOJisp8-wm5FCMSaBYoMO-ePT1sSXfZ+K1LAyxW=og@mail.gmail.com>
	<20111122213548.28715073@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111122213548.28715073@galadriel.home>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@oss.sgi.com, hank peng <pengxihan@gmail.com>

On Tue, Nov 22, 2011 at 09:35:48PM +0100, Emmanuel Florac wrote:
> Le Tue, 22 Nov 2011 11:22:15 +0800 vous ??criviez:
> 
> > I think I have already exported the root of my XFS filesystem, am I
> > right?
> 
> Yes, and the fsid stuff only relates to NFS v4, and as you aren't
> providing any fsid, you must be running NFS 3. Now maybe you could use
> NFS 4 instead of NFS 3?

The fsid option is in no way related to NFSv4.  It just overrides the
default fsid taken from the st_dev field of the mounted filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
