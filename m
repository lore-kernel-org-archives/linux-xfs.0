Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51748 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751868AbdBAT6M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Feb 2017 14:58:12 -0500
Subject: Re: I had an occasion that XFS is not able to fully detect or recover
 from severe file system corruption
References: <CAEtPA0BOdAHjtoRrrX3Ha6iHe4VXOUxNe7KPaEdJM=8yYstQMA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <68f4911f-a55a-c21c-1eb0-91c81187c774@sandeen.net>
Date: Wed, 1 Feb 2017 13:58:10 -0600
MIME-Version: 1.0
In-Reply-To: <CAEtPA0BOdAHjtoRrrX3Ha6iHe4VXOUxNe7KPaEdJM=8yYstQMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Patrick Dung <mpatdung@gmail.com>, linux-xfs@vger.kernel.org

On 2/1/17 12:53 PM, Patrick Dung wrote:
> Hi guys,
> 
> The problem happened in last year. I do not have the corrupted file
> system now. But I would like to discuss it. Any comment is welcomed.
> 
> I was using Fedora 24. I had an XFS file system in an hard drive. I
> had used some kind of  SSD write back caching on top of the hard
> drive.
> 
> Somehow the SSD was removed and when the system is rebooted, the XFS
> file system could not be mounted.
> 
> I run xfs_repair, it reported some files are corrupted. It had
> completed the repair of file system and some files were corrupted.
> Then I could mount the filesystem. I started using the existing files
> that did not have corruption. After sometime, the file system stopped
> again because it detected XFS file system is corrupted.
> 
> Then I run xfs_repair again and it found additional files were still corrupted.
> 
> So I have a question if xfs_repair is able to fully detect all files
> that are corrupted by running xfs_repair only once.

Yes, xfs_repair is intended to fix everything on the first pass.  Rarely,
there are bugs when it does not.

It's also possible that the filesystem somehow got re-corrupted between
the runs.

-Eric

> Best regards,
> Patrick
