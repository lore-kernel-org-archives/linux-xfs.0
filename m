Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47262 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755268AbdLONUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 08:20:35 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: CPU-intensive code in xfs
Message-ID: <27280b30-dfdf-2bb9-651d-1c23790ba568@oracle.com>
Date: Fri, 15 Dec 2017 08:20:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, hch@lst.de, david@fromorbit.com, cmaiolino@redhat.com, bfoster@redhat.com

Hi,

I'm working on a project called ktask[*], a generic framework to 
multithread cpu-intensive kernel work.  So far, I've found several 
possible users in the mm code.

Are there places in XFS that might benefit from being multithreaded?

As an example, Darrick thought maybe quotacheck could use it.  Have 
people seen cases where it takes up a lot of CPU time?

Many thanks,
Daniel

[*] https://patchwork.kernel.org/patch/10093673
