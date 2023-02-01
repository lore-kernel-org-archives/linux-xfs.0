Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504BDC636D3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 13:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjBANSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 08:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjBANSR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 08:18:17 -0500
X-Greylist: delayed 1369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Feb 2023 05:18:07 PST
Received: from mailgate.ics.forth.gr (mailgate.ics.forth.gr [139.91.1.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAAB1E1DC
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 05:18:06 -0800 (PST)
Received: from av3.ics.forth.gr (av3in.ics.forth.gr [139.91.1.77])
        by mailgate.ics.forth.gr (8.15.2/ICS-FORTH/V10-1.8-GATE) with ESMTP id 311Ct8pb029890
        for <linux-xfs@vger.kernel.org>; Wed, 1 Feb 2023 14:55:13 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; d=ics.forth.gr; s=av; c=relaxed/simple;
        q=dns/txt; i=@ics.forth.gr; t=1675256113; x=1677848113;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=my9OmN2yJ7v8zwxuMeTu/SlcSHdGlYXyO1fke0XHdVU=;
        b=ZHZkMtO+NDE9jO8K7Q7A/iGO673ug0LcQrw0siItNF4d+EuzeL8uVlbdECP9a5lH
        lbVzhdT/mEArp+wfX7duxs3jRf4sCWRZKEEnFAMNIfWIJ5amj2cTNLYf8i/LEfB1
        085WQmJZDUxsq9CA2CEGW/uPKEAj7ntt4nnVyFt6188bvQ71tKZpXBDOvfcng5FU
        S0jZanPnUZpxMYj22L/0+9duXEoBOZDLE0r7Ec6EWLBs3hW9GbNOVuPd9crzvx+Y
        CNUwZxtQis5+cBEZ0prkZOorvFA1HWWTwzHekS5z7FfvF/tjDttObQCZaaR2YqiM
        9FaE0Zjy6GLxPALPGBs9nA==;
X-AuditID: 8b5b014d-a02eb700000025c1-70-63da6131e204
Received: from enigma.ics.forth.gr (enigma.ics.forth.gr [139.91.151.35])
        by av3.ics.forth.gr (Symantec Messaging Gateway) with SMTP id CC.B9.09665.1316AD36; Wed,  1 Feb 2023 14:55:13 +0200 (EET)
X-ICS-AUTH-INFO: Authenticated user: papadako at ics.forth.gr
MIME-Version: 1.0
Date:   Wed, 01 Feb 2023 14:55:12 +0200
From:   Panagiotis Papadakos <papadako@ics.forth.gr>
To:     linux-xfs@vger.kernel.org
Subject: xfs_repair: fatal error -- couldn't map inode 13199169, err = 117
Message-ID: <86696f1f1b39a175e99f43128f09a722@mailhost.ics.forth.gr>
X-Sender: papadako@mailhost.ics.forth.gr
Organization: FORTH-ICS
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsXSHT1dWdcw8VayQV+/uMWuPzvYHRg9Pm+S
        C2CM4rJJSc3JLEst0rdL4MqYf2U1S0ErS8XTw+dZGhinMncxcnJICJhIvL+8lA3EFhI4wihx
        9EguRNxWomn9I7A4r4CgxMmZT1hAbBYBVYmp3y+xg9hsAkYSO+ZdYASxRQRkJSatPAVmCwt4
        STxaf4EZotdF4vnkJqYuRg6gmRoSV64VgIT5BcQl5rTfZwUJMwtYS7TvMQAJMwvIS2x/O4d5
        AiPvLCSLZyFUzUJStYCReRWjQGKZsV5mcrFeWn5RSYZeetEmRnCYMPruYLy9+a3eIUYmDsZD
        jBIczEoivIpcN5OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ856wXZAsJJCeWJKanZpakFoEk2Xi
        4JRqYFLX/xdR4jDT1yUtVrBtmeicFT5Wpy7Xps+deWnKpSW5XgH8/OpyeVYcIh5cIrd7N62O
        trX0KrILmBq0iVtmYt/qr5WqO1ZHKf/Nblvy3PH+D73G04bB59SeWXD5dmhGv96xWdsv5SbL
        /47jp4+e57j59HryD4ljkqVPG+9nnpF+/D02uG0xL1/Rkr7ZKy1Fw2RPH+/oXvaZe86cd3bO
        13Yd3VzpkF7lvk322o+jCb8nvfnwyWfPwmZr66DD7Du26vqGaDdusdvmFFXwXqxqffvZiRPZ
        PCLyHvKl/0+d2HBdxfqN/oyAp+IiPP3hcbt27JwV5uzw6Kadi8fK3zsPnfOY8Gb/WtWf5kqb
        njyw6FdiKc5INNRiLipOBADPWwbLggIAAA==
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dear all,

I am using XFS on an ICY-BOX 4-bay USB RAID enclosure which 
unfortunately has been corrupted (probably due to some power-down).

I have used xfs_repair -L, which after a huge number of messages about 
free inode references, bad hash tables, etc, fails with the following 
error:

fatal error -- couldn't map inode 13199169, err = 117

Is there anything I can do or should I consider my data lost?

xfs_repair version 6.0.0
kernel: 6.1.0-rc5

Best regards

Panagiotis, a novice XFS user
