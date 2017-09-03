Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51912 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752827AbdICDIm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 2 Sep 2017 23:08:42 -0400
Subject: Re: error: "Your hard drive is failing" ???
References: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b699dac3-321a-9029-87cb-2b5ced17ddd1@sandeen.net>
Date: Sat, 2 Sep 2017 22:08:41 -0500
MIME-Version: 1.0
In-Reply-To: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ToddAndMargo <ToddAndMargo@zoho.com>, linux-xfs@vger.kernel.org

On 9/2/17 9:48 PM, ToddAndMargo wrote:
> Dear Xfs,
> 
> Scientific Linux 7.3
> 
> $ rpm -qa \*xfsdump\*
> xfsdump-3.1.4-1.el7.x86_64
> 
> When I do a backup to /dev/sda1 (/lin-bak), I get told
> 
>     WARNING: Your hard drive is failing
>     Device: /dev/sda [SAT], unable to open device

That's a message from smartctl, it has nothing to do with 
xfs or xfsdump.  It's probably related to your creative use
of hotplug.

-Eric
