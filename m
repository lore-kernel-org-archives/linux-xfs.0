Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35954 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726625AbeHZTlG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Aug 2018 15:41:06 -0400
Subject: Re: null pointer dereference in xfs_dir_isempty()
References: <B0576452-CD35-40B4-ADA0-9385423B85C0@gatech.edu>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f067f6c3-49ae-65e7-d1c8-dc81348aa6b9@sandeen.net>
Date: Sun, 26 Aug 2018 10:58:09 -0500
MIME-Version: 1.0
In-Reply-To: <B0576452-CD35-40B4-ADA0-9385423B85C0@gatech.edu>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Xu, Wen" <wen.xu@gatech.edu>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>



On 8/24/18 9:06 AM, Xu, Wen wrote:
> Hi,
> 
> I found a new bug by fuzzing in upstream kernel.
> 
> Check details at: https://bugzilla.kernel.org/show_bug.cgi?id=200925
> 
> -Wen
> 

I think we need a size-vs-format check in xfs_ifork_verify_data, trying
that out now.

-Eric
