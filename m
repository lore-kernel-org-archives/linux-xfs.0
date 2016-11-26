Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49750 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbcKZGFQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 26 Nov 2016 01:05:16 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <1673187.nXukm9ZPb1@libor-nb>
Date: Sat, 26 Nov 2016 00:05:14 -0600
Content-Transfer-Encoding: 8BIT
Message-Id: <B169ECD9-00C2-43F8-A0CD-CA697CCCD6E1@sandeen.net>
References: <5244720.RPRsZ88NJ0@libor-nb> <2152865.L3K5Xz7SXO@libor-nb> <20161110213057.GH28922@dastard> <1673187.nXukm9ZPb1@libor-nb>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?Q?Libor_Klep=C3=A1=C4=8D?= <libor.klepac@bcom.cz>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Nov 23, 2016, at 5:40 AM, Libor Klepáč <libor.klepac@bcom.cz> wrote:
> 
> btw, it seems to contain strings from inside of files, is that normal? 
> It also contains strings from mail.log which is on another (ext4) filesystem.

Please try a newer version of metadump; it should not leak any stale data at all, and hopefully will not segfault, either.

Eric


