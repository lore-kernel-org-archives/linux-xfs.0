Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:49426 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752720AbeBACXc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jan 2018 21:23:32 -0500
Date: Wed, 31 Jan 2018 21:23:32 -0500
Subject: Re: [LSF/MM TOPIC] Virtual block address space mapping
Message-ID: <20180201022332.GD3814@fieldses.org>
References: <20180129100834.rhpgnz5572zxmqep@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180129100834.rhpgnz5572zxmqep@destitution>
From: bfields@fieldses.org (J. Bruce Fields)
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jan 29, 2018 at 09:08:34PM +1100, Dave Chinner wrote:
> I've implemented both sides on XFS to provide the capability for an
> XFS filesystem to host XFS subvolumes. however, this is an abstract
> interface and so if someone modifies ext4 to use a virtual block
> address space, then XFS will be able to host cloneable ext4
> subvolumes, too. :P

This sounds really interesting.

Would it be possible to write up a brief summary of your current
interface?  Even if it's not completely correct it might be a useful
starting point.

--b.
