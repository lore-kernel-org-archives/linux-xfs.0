Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51404 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728545AbeJWASP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Oct 2018 20:18:15 -0400
Subject: Re: Segmentation fault in xfs_repair
From: Eric Sandeen <sandeen@sandeen.net>
References: <CA+MkmrPWg=pD5t-bt8ye36bi8prep+FjM_n-L4XnG-PRJc--7w@mail.gmail.com>
 <1ec797d1-3875-467c-8d46-335a1668fa06@sandeen.net>
Message-ID: <3078c092-02cb-9c3f-a4b9-e0c4ab822583@sandeen.net>
Date: Mon, 22 Oct 2018 10:59:08 -0500
MIME-Version: 1.0
In-Reply-To: <1ec797d1-3875-467c-8d46-335a1668fa06@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Oleg Davydov <burunduk3@gmail.com>, linux-xfs@vger.kernel.org



On 10/22/18 10:06 AM, Eric Sandeen wrote:
> On 10/20/18 7:43 AM, Oleg Davydov wrote:
>> I try to repair file system from corrupter drive and this leads to
>> Segmentaion Fault in xfs_repair. You can see some logs here (incl.
>> stack trace from coredump): https://pastebin.com/farKCDRi
>>
>> I tried xfsprogs-4.14.0 (currently installed on my system), custom
>> build from git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git, from
>> master (3caeb69c) and from libxfs-4.19-sync (b5c71bcd), all ended in
>> the same result.
>>
>> Please suggest me how to fix it, how to get some more information
>> about the problem or how can I workaround it. Additional problem is
>> that I can't even mount filesystem now (mount fails with Corruption
>> warning: Metadata has LSN (1674570203:54480) ahead of current LSN
>> (1:8). Please unmount and run xfs_repair (>= v4.3) to resolve.)
> 
> If you could provide an xfs_metadump image (compressed) I can take a look
> at it.  A metadump contains no file data, should obfuscate most metadata,
> and should zero out unused portions of metadata sectors.  Feel free to
> provide it off-list for maximum privacy.
> 
> I'm actually looking at something right now that may be similar, so
> you have good timing.

got it offline, thanks.

-Eric
