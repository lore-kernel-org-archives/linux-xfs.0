Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A9287F50
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 15:11:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E2E48F8037
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 13:11:05 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id s5WeuEjUxj1stleT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 May 2015 13:11:03 -0700 (PDT)
Date: Tue, 19 May 2015 13:10:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Let's get a File & Storage miniconf going at LPC2015!
Message-ID: <20150519201055.GD27115@birch.djwong.org>
References: <20150515205825.GC24967@birch.djwong.org>
	<20150519154200.GA2559@kmo-pixel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150519154200.GA2559@kmo-pixel>
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
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, May 19, 2015 at 08:42:00AM -0700, Kent Overstreet wrote:
> On Fri, May 15, 2015 at 01:58:25PM -0700, Darrick J. Wong wrote:
> > We of course are not limited to just those topics -- if there's something
> > you'd really like to discuss with everyone, please add that to the wiki.
> > I realize that mid-August is family vacation time for many people, but
> > those are the constraints the conference has to work with this year.
> > There are fun things to do around Seattle, and that's probably the best
> > time of year to visit.
> 
> It's getting near time for the big bcachefs announcement :)
> 
> Also, stable pages - what's been going on there? Last I heard you were talking
> about using the page migration code to do COW, did anything come of that? I just
> added data checksumming/compression to bcachefs, so that's been fresh on my
> mind.

Yeah.  I never figured out a sane way to migrate pages and keep everything
else happy.  Daniel Phillips is having a go at page forking for tux3; let's
see if the questions about that get resolved.

> Also, there's probably always going to be situations where we're reading or
> writing to pages user space can stomp on (dio) - IMO we need to add a bio flag
> to annotate this - "if you need this to be stable you have to bounce it".
> Otherwise either filesystems/block drivers are going to be stuck bouncing
> everything, or it'll just (continue to be) buggy.

Well, for now there's BIO_SNAP_STABLE that forces the block layer to bounce it,
but right now ext3 is the last user of it, and afaict btrfs is the only other
FS that takes care of stable pages on its own.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
