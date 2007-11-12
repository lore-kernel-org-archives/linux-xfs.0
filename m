Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 07:21:57 -0800 (PST)
Received: from relay00.pair.com (relay00.pair.com [209.68.5.9])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lACFLKmj017458
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 07:21:24 -0800
Date: Mon, 12 Nov 2007 15:54:48 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs options
Message-ID: <20071112155448.26a2b479@harpe.intellique.com>
In-Reply-To: <473844ED.7080605@jamendo.com>
References: <473844ED.7080605@jamendo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Amandine AUPETIT <amandine@jamendo.com>
Cc: xfs@oss.sgi.com

Le Mon, 12 Nov 2007 13:19:57 +0100
Amandine AUPETIT <amandine@jamendo.com> écrivait:

> I have a 7tb XFS filesystem. The partition is supposed to stock big 
> files between 2mo and 50mo. Quite no small files.
> 
> So i'm trying to adapt the mount option to what I need, and what I
> need is security. I want to be sure that NONE of the files will be
> lost, even if there's a power failure.

Unfortunately there isn't any such option. A power failure may be the
cause of lost files on any filesystem.

> For now, I just tried the noatime mount option, I know there is a lot
> of options, but I don't really understand what they stand for.
> 
> Do you have any suggestion to make my filesystem safer ?
> 

Use redundant power supplies, and UPS; and make backups. Backups,
backups, and backups. Keep a copy (with rsync or rsnapshot) on a
similar server as your main backup, and a backup on tape.
If your data is precious, JUST MAKE BACKUPS. 

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
