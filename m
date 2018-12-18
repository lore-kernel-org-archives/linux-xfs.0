Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56468 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbeLRUcp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 15:32:45 -0500
Subject: Re: XFS metadata corruption
References: <93641AD9-AD79-4400-8C7F-14C5D7746709@gmail.com>
 <5fe33e22-e034-db8c-f62d-8124e731c5dd@sandeen.net>
 <6E2E81FA-9677-4385-9ADF-46E06B6F5150@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5804b809-4656-9471-9d06-64c5a58e99b0@sandeen.net>
Date: Tue, 18 Dec 2018 14:32:44 -0600
MIME-Version: 1.0
In-Reply-To: <6E2E81FA-9677-4385-9ADF-46E06B6F5150@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Predrag Mijatovic <predmijat@gmail.com>
Cc: linux-xfs@vger.kernel.org

On 12/18/18 2:26 PM, Predrag Mijatovic wrote:
> It’s a 12T partition so it will take a while (plus I can’t start it before tomorrow morning)

Just FYI, a metadump is metadata-only so the time and space it takes will
be a) much less than a full 12T and b) proportional to the amount of
metadata you have in the filesystem.

Note, the fs does need to be offline to get a metadump.

Thanks,
-Eric
