Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7QEfQdH106000 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 09:41:26 -0500
Received: from lulu.zabbo.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2821513A4C9A
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 07:44:22 -0700 (PDT)
Received: from lulu.zabbo.net (lulu.zabbo.net [69.168.54.52]) by cuda.sgi.com
	with ESMTP id ubDW3o9a2FPIWCjd for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2011 07:44:22 -0700 (PDT)
Date: Fri, 26 Aug 2011 07:41:24 -0700
From: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110826144124.GA17519@lulu.zabbo.net>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
	<0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
	<20110826013528.GW3162@dastard>
	<CANGUGtC1qk2Tkv42fvibUKiEJz_MnNiV-nQ7T-_woppVhjQK-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANGUGtC1qk2Tkv42fvibUKiEJz_MnNiV-nQ7T-_woppVhjQK-Q@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>, viro@zeniv.linux.org.uk

> > Hole: a range of the file that contains no data or is made up
> > entirely of =A0NULL (zero) data. Holes include preallocated ranges of
> > files that have not had actual data written to them.

> No for me. A hole is made up of zero data? It's a strange definition
> for me.

It's a very natural definition for me.  It mirrors the behaviour of
read() of sparse data inside i_size that file system authors already
have to consider.

It's also a reminder for people that this interface is about avoiding
reading zeros.  Systems that track contents can do this for files that
had tons of zeros written.  The data is there but the app is
specifically asking us to skip it by using SEEK_DATA.

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
