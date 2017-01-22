Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44174 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750907AbdAVQtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Jan 2017 11:49:01 -0500
Message-ID: <1485103612.2504.2.camel@HansenPartnership.com>
Subject: Re: [PATCH 02/17] xfsprogs: Space management tool
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 22 Jan 2017 08:46:52 -0800
In-Reply-To: <148498609772.16675.551393252011136759.stgit@birch.djwong.org>
References: <148498608472.16675.14848042961636871812.stgit@birch.djwong.org>
         <148498609772.16675.551393252011136759.stgit@birch.djwong.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <dchinner@redhat.com>, sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, 2017-01-21 at 00:08 -0800, Dave Chinner wrote:
> xfs_spaceman is intended as a diagnostic and control tool for space
> management operations within XFS. Operations like examining free
> space, managing allocation policies, issuing block discards on free
> space, etc.
> 
> The tool is modelled on the xfs_io interface, allowing both
> interactive and command line control of the tool, enabling it to be
> used in scripts and automated management tools.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Please don't do this: a forged from address is the most classic
indicator of spam and a significant number of email servers will pick
it up and discard the mail.  The way you send someone else's patch is
to send it from your own email, but at the top of the body have

From: Dave Chinner <dchinner@redhat.com>

And then you also need to append your own signoff because you're
retransmitting someone else's work.

James


