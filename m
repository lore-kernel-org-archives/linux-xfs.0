Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36906 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751576AbdFFTGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2017 15:06:09 -0400
Date: Tue, 06 Jun 2017 15:05:55 -0400 (EDT)
Message-Id: <20170606.150555.855421580901340490.davem@davemloft.net>
Subject: Re: [sparc64] crc32c misbehave
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170531.124916.1406665885250072302.davem@davemloft.net>
References: <ccdf645b-e22f-ef71-53df-993cc45869c0@sandeen.net>
        <260a016f-0f17-e286-ceca-83b6977f2fc0@sandeen.net>
        <20170531.124916.1406665885250072302.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: matorola@gmail.com, sparclinux@vger.kernel.org, linux-xfs@vger.kernel.org


Just FYI, I've meanwhile pushed a fix for the GCC bug that created
this mess to all active branches.
