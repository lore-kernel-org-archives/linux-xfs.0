Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f41.google.com ([209.85.221.41]:40393 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeILVpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 17:45:11 -0400
Received: by mail-wr1-f41.google.com with SMTP id n2-v6so2747963wrw.7
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 09:39:50 -0700 (PDT)
Date: Wed, 12 Sep 2018 18:39:46 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Strange XFS problem
Message-ID: <20180912163946.jjc4ufjyfcuideyq@odin.usersys.redhat.com>
References: <1063031109.4602643.1536739675362.JavaMail.zimbra@casalogic.dk>
 <20180912105938.jbziznvnrheldudj@odin.usersys.redhat.com>
 <1190577571.4632210.1536752399899.JavaMail.zimbra@casalogic.dk>
 <notmuch-sha1-960c954e5404b5b2f083d150633af0b7848ec14c>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <notmuch-sha1-960c954e5404b5b2f083d150633af0b7848ec14c>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Troels Hansen <th@casalogic.dk>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

I think it's quite clear I hit 'send' by mistake :)

On Wed, Sep 12, 2018 at 05:26:50PM +0200, Carlos Maiolino wrote:
> Hi,
> 
> On Wed, Sep 12, 2018 at 01:39:59PM +0200, Troels Hansen wrote:
> > Hi Carlos
> > 
> > 
> > ----- On Sep 12, 2018, at 12:59 PM, Carlos Maiolino cmaiolino@redhat.com wrote:
> > 
> > > In the mean time, can you provide more information about the systems where you
> > > are hitting this issue?
> > > 
> > > Mainle the storage configuration and the xfs_info output of the affected
> > > filesystems.
> > > 
> > > FWIW:
> > > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> > 
> > 
> > $ uname -a
> > Linux ged 4.15.0-32-generic #35~16.04.1-Ubuntu SMP Fri Aug 10 21:54:34 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > 
> > $ sudo xfs_info /z/home
> > meta-data=/dev/sda               isize=256    agcount=102, agsize=268435328 blks
> >          =                       sectsz=512   attr=2, projid32bit=0
> >          =                       crc=0        finobt=0 spinodes=0
> > data     =                       bsize=4096   blocks=27345289216, imaxpct=1
> >          =                       sunit=128    swidth=256 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> > log      =internal               bsize=4096   blocks=521728, version=2
> >          =                       sectsz=512   sunit=8 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> 
> Ok, the settings look reasonable for the size of the filesystem, agcount and log
> size looks sane, the stripe configuration doesn't though, based on your raid
> configuration. And you're using V4 filesystem, which change things a bit.
> > 
> 
> > $ cat /proc/mounts
> > .....
> > /dev/sda /z/home xfs rw,relatime,attr2,inode64,sunit=1024,swidth=2048,noquota 0 0
> 
> Mounted with different alignment. 512KiB sunit and a 1MiB width.
> > 
> > Raid50, 8 disk per span, 4 spans.
> > RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3
> > Size                : 101.869 TB
> > Sector Size         : 512
> > Parity Size         : 14.552 TB
> > State               : Optimal
> > Strip Size          : 512 KB
> > Number Of Drives per span:8
> > Span Depth          : 4
> 
> So, if I understand correctly your configuration (I'm not really used to dell
> namings), you have:
> 
> 4 RAID5 arrays using 8 disk each, nested in a RAID0 array, which has a 512KiB
> stripe size.
> 

" If I'm right here, you should be using  stripe unit 512K and stripe width
 2MiB. (sunit 1024 swidth 4096)"

I didn't have too much time to think about it by now, and I am not sure if
setting the correct stripe alignment is the culprit here (most likely not), and
since I didn't think about it enough yet, I was postponing the e-mail and hit
'send' instead. My apologies about it.

I need to give it some extra thought to get some idea on how to help you here,
or have any reason to ask you to use a newer kernel. Again, my apologies for
hitting send too soon.

> > 
> > 6Gb cache on controller, battery backed up.
> > 
> > Disks are 4Tb Toshiba 12G SAS disks.
> > 
> > Not running LVM.
> > 
> 
> -- 
> Carlos

-- 
Carlos
