Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 05 Oct 2007 00:44:59 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.179])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l957ijPC012167
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2007 00:44:47 -0700
Received: by py-out-1112.google.com with SMTP id u77so885928pyb
        for <xfs@oss.sgi.com>; Fri, 05 Oct 2007 00:44:46 -0700 (PDT)
Message-ID: <d55656c10710042344u4c9851c2mebcd9188a624610b@mail.gmail.com>
Date: Fri, 5 Oct 2007 08:44:45 +0200
From: "Peter Gervai" <grinapo@gmail.com>
Subject: Re: xfs_repair phase6 repeatedly dies : name create failed in lost+found (117), filesystem may be out of space
In-Reply-To: <op.tzo76uks3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d55656c10710041510y79cac2abv1c4d30d3afe1949f@mail.gmail.com>
	 <op.tzo76uks3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 10/5/07, Barry Naujok <bnaujok@sgi.com> wrote:
> On Fri, 05 Oct 2007 08:10:49 +1000, Peter Gervai <grinapo@gmail.com> wrote:
>
> > Hello,
> >
> > xfs_repair in Debian sid (v2.9.0) repeatedly dies on a poor filesystem
> > with that message:
> >
> > fatal error -- name create failed in lost+found (117), filesystem may
> > be out of space
> >
> > The filesystem is not out of space:
> >
> > Filesystem                          1K-blocks     Used      Available
> > Use% Mounted on
> > /dev/mapper/vg0-backup    419379200 144029144 275350056  35%
> > /var/lib/backuppc
> >
> > I tried to find error 117 but it seems to be well hidden. :-) I try
> > newer xfs_repair but I doubt it'll help. Any idea?
>
> Can you do a "df -i" as well?

Yes:

Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/vg0-backup
                     419430400 3475741 415954659    1% /var/lib/backuppc


> The other option is to run xfs_metadump from xfsprogs 2.9.4 so I can
> perform some analysis as to why it's failing.

Errrmm...

# xfs_metadump -wg /dev/vg0/backup vg0.backup.metadump
Copied 158208 of 3719360 inodes (0 of 1 AGs)
/usr/sbin/xfs_metadump: line 31:  1778 Segmentation fault      (core
dumped) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1

Do you want the partial dump, or should I try something tricky?

-- 
 byte-byte,
    grin
