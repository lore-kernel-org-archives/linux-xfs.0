Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:63220 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754465AbdCWOLN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Mar 2017 10:11:13 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Selectively backup based on specific date
Date: Thu, 23 Mar 2017 15:11:07 +0100
Message-ID: <1904662.EPkO7u6dZY@xrated>
In-Reply-To: <0c190757-c4ac-ae5c-6e1c-b9be37470be5@lueckdatasystems.com>
References: <0c190757-c4ac-ae5c-6e1c-b9be37470be5@lueckdatasystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Lueck <mlueck@lueckdatasystems.com>
Cc: linux-xfs@vger.kernel.org

Hi Michael,

On Donnerstag, 23. März 2017 09:21:56 Michael Lueck wrote:
> Greetings,
> 
> I am looking for the correct xfsdump syntax to backup dirs/files newer than
> a certain date.

xfsdump is a tool in the tradition of unix filesystem dump utilities.
Those always dump a full filesystem, and consequently, fully restore  
filesystems only.

> I have not found mention of such an option / capability within xfsdump.
> Hopefully there is a creative way to do the selective backup.

Using a linux derivate, there are plenty of more or less creative options to 
selectively backup/restore arbitrary file systems, but this is rather OT for 
the ML. 

Here are some of my favorite tools:
	rsync for ad hoc operations, 
	rsnapshot for regular file based backups, 
	borg for deduplicated backups (e.g. VM images).

They all perform nicely over LAN as well.

If you seek professional support in this regard, send an PM.

Cheers,
Pete
