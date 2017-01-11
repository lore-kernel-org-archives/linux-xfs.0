Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756370AbdAKJKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 04:10:13 -0500
Date: Wed, 11 Jan 2017 01:10:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Reading about CoW architecture / Performance Limits
Message-ID: <20170111091011.GA29454@infradead.org>
References: <BC894F29-47E7-47A3-93FB-3E4EEE1DCDD5@flyingcircus.io>
 <20170110074524.GI14038@birch.djwong.org>
 <C97BB12C-3C30-493B-BE9A-9E8C7CB5D1A4@flyingcircus.io>
 <9713E613-6953-4AD3-89B1-C0EF639E771C@flyingcircus.io>
 <20170111080544.GB5883@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170111080544.GB5883@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christian Theune <ct@flyingcircus.io>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 12:05:44AM -0800, Darrick J. Wong wrote:
> > 3. There appears to be code that allows retroactively creating CoW for
> > two files that existed separately before. Is that (planned to be)
> > exposed to userland?
> 
> No plans for that at the moment.  There used to be a debugging knob, but
> it was ripped out before upstreaming the code.

I think he's asking for the dedup ioctl, which is supported.
