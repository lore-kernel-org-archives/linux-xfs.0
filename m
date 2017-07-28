Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36975 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdG1QuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2017 12:50:22 -0400
Date: Fri, 28 Jul 2017 09:50:19 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2 13/15] common: remove IRIX-specific code
Message-ID: <20170728165019.GA144538@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
 <20170721043853.364-14-ebiggers3@gmail.com>
 <20170728111926.GE9167@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170728111926.GE9167@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

On Fri, Jul 28, 2017 at 07:19:26PM +0800, Eryu Guan wrote:
> > -#
> > -# Filtering of Irix character hwgraph device names
> > -# e.g.
> > -# chardev: /hw/node/xtalk/15/pci/0/scsi_ctlr/0/target/1/lun/0/disk/partition/4/char
> > -# blkdev:  /dev/dsk/dks0d1s4
> > -#
> > -_filter_devchar()
> > -{
> > -    $AWK_PROG '
> > -	/\/hw\/node/ {
> > -	    sub(/\/hw.*scsi_ctlr\//,"/dev/dsk/dks")  # blah blah /dev/dsk/dks0/target/1/....
> > -	    sub(/\/target\//,"d")                    # blah blah /dev/dsk/dks0d1/lun/0/disk.....
> > -	    sub(/\/lun.*partition\//,"s")            # blah blah /dev/dsk/dks0d1s4/char
> > -	    sub(/\/char/,"")			     # blah blah /dev/dsk/dks0d1s4
> > -	}
> > -	{ print }
> > -    '
> > -}
> > -
> >  
> >  #
> >  # Filter out the non-deterministic dump msgs from
> > @@ -824,7 +803,6 @@ _filter_devchar()
> >  #
> >  _dump_filter_main()
> >  {
> > -  _filter_devchar |\
> 
> I added this _filter_devchar function back as xfs/061 needs it,
> otherwise it fails like:
> 
>  -xfsrestore: volume: /dev/dsk/dks0d2s1
>  +xfsrestore: volume: /hw/node/io/gio/hpc/scsi_ctlr/0/target/2/lun/0/disk/partition/1/char
> 
> I think this is the safest and easiest thing to do at this moment.
> 

Okay, that's fine for now.  Thanks for testing!

Eric
