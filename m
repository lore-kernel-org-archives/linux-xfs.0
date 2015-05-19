Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 94F7D7F50
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 10:43:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 119B7AC001
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 08:43:49 -0700 (PDT)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
	[209.85.192.170]) by cuda.sgi.com with ESMTP id
	hbvH3mo2UAvdR6mA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 May 2015 08:43:47 -0700 (PDT)
Received: by pdea3 with SMTP id a3so30421940pde.2
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 08:43:46 -0700 (PDT)
Date: Tue, 19 May 2015 08:42:00 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Let's get a File & Storage miniconf going at LPC2015!
Message-ID: <20150519154200.GA2559@kmo-pixel>
References: <20150515205825.GC24967@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150515205825.GC24967@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, May 15, 2015 at 01:58:25PM -0700, Darrick J. Wong wrote:
> We of course are not limited to just those topics -- if there's something
> you'd really like to discuss with everyone, please add that to the wiki.
> I realize that mid-August is family vacation time for many people, but
> those are the constraints the conference has to work with this year.
> There are fun things to do around Seattle, and that's probably the best
> time of year to visit.

It's getting near time for the big bcachefs announcement :)

Also, stable pages - what's been going on there? Last I heard you were talking
about using the page migration code to do COW, did anything come of that? I just
added data checksumming/compression to bcachefs, so that's been fresh on my
mind.

Also, there's probably always going to be situations where we're reading or
writing to pages user space can stomp on (dio) - IMO we need to add a bio flag
to annotate this - "if you need this to be stable you have to bounce it".
Otherwise either filesystems/block drivers are going to be stuck bouncing
everything, or it'll just (continue to be) buggy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
