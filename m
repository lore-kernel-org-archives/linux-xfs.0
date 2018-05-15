Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bullwinkle.deer-run.com ([50.23.32.3]:32975 "EHLO
        bullwinkle.deer-run.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbeEOEdJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 00:33:09 -0400
Received: from [192.168.0.6] (97-102-6-26.res.bhn.net [97.102.6.26] (may be forged))
        (authenticated bits=0)
        by bullwinkle.deer-run.com (8.14.4/8.14.4) with ESMTP id w4F4X1HX023053
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 23:33:05 -0500
From: Hal Pomeranz <hal@deer-run.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (1.0)
Date: Tue, 15 May 2018 00:33:01 -0400
Subject: XFS 2038 rollover?
Message-Id: <7BDFF86A-062B-4731-97E8-33E920CF7E7D@deer-run.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I was curious about the roadmap for solving the 32-bit signed rollover issue for XFS (aka the “Y2K38” issue). You could cheat in a similar fashion to EXT4 and use the upper two bits of the nsec values to extend the seconds field to 34 bits. Or will the inode core be expanding to allow full 64-bit seconds values? Or is there some other plan?

I’ve checked the FAQ and haven’t been able to find anything via Google. 

--Hal
