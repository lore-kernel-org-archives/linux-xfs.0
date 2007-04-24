Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 23:46:40 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3O6kZfB032255
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 23:46:37 -0700
Message-ID: <21485.194.246.123.250.1177397184.squirrel@derchris.gotdns.org:8080>
In-Reply-To: <20070423211952.GA13572@infradead.org>
References: <Pine.LNX.4.64.0704021914060.3963@sheep.housecafe.de>
    <20603.194.246.123.250.1177344480.squirrel@derchris.gotdns.org:8080>
    <462D0D23.7010803@sandeen.net> <20070423211952.GA13572@infradead.org>
Date: Tue, 24 Apr 2007 07:46:24 +0100 (BST)
Subject: Re: possible recursive locking detected
From: "Christian Kujau" <lists@nerdbynature.de>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, April 23, 2007 22:19, Christoph Hellwig wrote:
> It's not really cosmetic.  It means i_lock and i_iolock are beeing
> acquired without an order that is detectable by lockdep.  At the very first
> it means annotations for lockdep are missing, because acquiring two
> per-inode locks at the same time is a basic fact in unix filesystems.

Thank you both for your comments, now I can sleep better again ;)

Christian.
-- 
BOFH excuse #442:

Trojan horse ran out of hay
