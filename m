Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42296 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbeK2JnA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Nov 2018 04:43:00 -0500
Subject: Re: [PATCH 1/6] xfs_io.8: rearrange command listings by section
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181072098.3727.12783001969841425328.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8c568cb2-4931-288c-0be3-68bd5caef634@sandeen.net>
Date: Wed, 28 Nov 2018 16:39:47 -0600
MIME-Version: 1.0
In-Reply-To: <154181072098.3727.12783001969841425328.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/9/18 6:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Most of the commands listed under "OTHER COMMANDS" apply to files or
> filesystems.  Create two new sections for that and populate them
> appropriately.
> 
> Here's what moves:
> 
> fsmap: moves from file io commands to filesystem commands
> utimes: moves from file io commands to file commands
> 
>>From the OTHER COMMANDS section:
> 
> lsattr/chattr: moves to file commands
> flink: moves to file commands
> stat/statx: moves to file commands
> lsproj/chproj: moves to file commands
> parent: moves to file commands
> [gs]et_encpolicy: moves to file io commands
> freeze/thaw: move to filesystem commands
> inject: move to filesystem commands
> resblks: move to filesystem commands
> shutdown: move to filesystem commands
> statfs: move to filesystem commands
> label: move to filesystem commands

Thank you for getting this better organized.  Of course, I have
some questions.  :)

What does "FILE COMMANDS" vs. "FILE I/O COMMANDS" mean, exactly?
I ask because for example bmap & fiemap are still under FILE IO but
they... really don't do file IO.  What's your intended distinction
with these new sections?

Thanks,
-Eric
