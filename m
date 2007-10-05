Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 17:37:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l950bCr9012289
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 17:37:14 -0700
Date: Fri, 05 Oct 2007 10:41:08 +1000
Subject: Re: xfs_repair phase6 repeatedly dies : name create failed in lost+found (117), filesystem may be out of space
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <d55656c10710041510y79cac2abv1c4d30d3afe1949f@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tzo76uks3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <d55656c10710041510y79cac2abv1c4d30d3afe1949f@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Gervai <grinapo@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, 05 Oct 2007 08:10:49 +1000, Peter Gervai <grinapo@gmail.com> wrote:

> Hello,
>
> xfs_repair in Debian sid (v2.9.0) repeatedly dies on a poor filesystem
> with that message:
>
> fatal error -- name create failed in lost+found (117), filesystem may
> be out of space
>
> The filesystem is not out of space:
>
> Filesystem                          1K-blocks     Used      Available
> Use% Mounted on
> /dev/mapper/vg0-backup    419379200 144029144 275350056  35%  
> /var/lib/backuppc
>
> I tried to find error 117 but it seems to be well hidden. :-) I try
> newer xfs_repair but I doubt it'll help. Any idea?

Can you do a "df -i" as well?

The other option is to run xfs_metadump from xfsprogs 2.9.4 so I can
perform some analysis as to why it's failing.

Regards,
Barry.
