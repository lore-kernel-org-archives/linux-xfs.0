Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 786E17CC9
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 16:57:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A2FB304059
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 14:57:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PGGbIMGDP4kNfpKd for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2016 14:57:37 -0700 (PDT)
Date: Wed, 21 Sep 2016 07:57:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Quick way to check if 32bit app can work with inode64
Message-ID: <20160920215735.GK340@dastard>
References: <CACNifpWojiF5XKwNgORqXCyuceRsGNQA+wEDWKpxdoEvJQ6+-w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACNifpWojiF5XKwNgORqXCyuceRsGNQA+wEDWKpxdoEvJQ6+-w@mail.gmail.com>
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
To: Marcin Sura <mailing-lists@sura.pl>
Cc: xfs@oss.sgi.com

On Tue, Sep 20, 2016 at 08:20:42PM +0200, Marcin Sura wrote:
> Hi Specialists!
> 
> I have a 32bit Java application reading and writing files to NFS share
> mounted on Windows 2008R2 server 64bit. The filesystem behind NFS share is
> of course XFS, created with default mkfs.xfs and mounted with inode64
> option.
> 
> I don't have access to app source code.

That won't help - who knows how windows API calls translate to
NFS operations.

> Is there a quick and fast way to check if the app can be safely used with
> inode64? Can I somehow force the files to be created with 64bit inodes
> number, so the app can read then?

On the NFS server, create a multi-TB filesystem (>16TB to be sure), make a few hundred
sub directories in the root, add a bunch of short files of known
contents to each sub directory. Export. 

Mont it on the client, then check you can list and read all the
files from the client, then have the client copy it all to a new set
of subdirs, then verify the copy on both client and server.  IF that
all works, then there's nothing obviously wrong with client side NFS
support handling inodes numbers larger than 32 bit.

Now do the same thing with your java application, and see if it has
problems listing and/or reading all the files...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
