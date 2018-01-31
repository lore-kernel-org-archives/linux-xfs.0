Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbeAaD4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 22:56:13 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [LSF/MM TOPIC][LSF/MM ATTEND] Parent pointer future use cases
Message-ID: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
Date: Tue, 30 Jan 2018 20:56:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>

Hi everyone!

Recently I have been working towards adding a new parent pointer patch 
set to xfs.  Briefly summarized, goal of the feature is to enable an 
application to quickly derive an inodes path from the mount point by 
storing information about the inodes parent(s) in an extended attribute. 
  Currently, I am aware of the intent to use the feature as part of an 
online scrub and repair feature.  Looking forward however, I would like 
to know about any other future coding intents that might make use of 
this feature.  For example, optimizing file system shrink or exportfs 
operations?  Are there certain interfaces or test cases that would be 
helpful to have?  I know the patch set has had a complicated history, so 
ideally being aware of how folks may go about using it may help to 
construct test cases to route out flaws sooner rather than later.

Thank you!

Allison Henderson
