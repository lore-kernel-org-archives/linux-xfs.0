Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45834 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdLMGUV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:20:21 -0500
Date: Tue, 12 Dec 2017 22:18:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ZOMG RFCRAP PATCH 0/2] xfs: horrifying eBPF hacks
Message-ID: <20171213061825.GO19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Richard Wareing <rwareing@fb.com>, david@fromorbit.com, hch@infradead.org

Heh.

So here's a kernel patch that builds on Josef's eBPF return value
override patch series to provide an eBPF-kprobe-overridable hook
function so that administrators can program XFS to redirect a file to
the rt device or the data device depending on their own funny
constraints any time that the system is doing the first write into an
empty file.

The second patch is against Brendan Gregg's bcc repository; it adds a
python script to compile and inject a sample eBPF program that behaves
(roughly) the same as Richard's earlier patches.

Soooo... rather than dumping a bunch of static code into XFS to support
his particular usecase, we're building him an eBPF Bazooka and telling
him to have fun. :P

(More generally, it's a science fair project for letting people
customize XFS behavior with eBPF in a controlled manner.)

--D
