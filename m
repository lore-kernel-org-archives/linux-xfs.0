Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbeKPCGi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Nov 2018 21:06:38 -0500
Date: Thu, 15 Nov 2018 10:58:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix shared extent data corruption due to missing
 cow reservation
Message-ID: <20181115155812.GA27656@bfoster>
References: <20181113170819.15220-1-bfoster@redhat.com>
 <63420b28-0415-061e-37cd-efe6f6a19f4b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63420b28-0415-061e-37cd-efe6f6a19f4b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 15, 2018 at 09:51:58AM -0600, Eric Sandeen wrote:
> On 11/13/18 11:08 AM, Brian Foster wrote:
> 
> > For example, a buffered write occurs across the file offset (in FSB
> > units) range of [29, 57]. A shared extent exists at blocks [29, 35]
> > and COW reservation already exists at blocks [32, 34]. After
> > accommodating a COW extent size hint of 32 blocks and the existing
> > reservation at offset 32, xfs_reflink_reserve_cow() allocates 32
> > blocks of reservation at offset 0 and returns with COW reservation
> > across the range of [0, 34]. The associated data fork extent is
> > still [29, 35], however, which isn't fully covered by the COW
> > reservation.
> > 
> > This leads to a buffered write at file offset 35 over a shared
> > extent without associated COW reservation. Writeback eventually
> > kicks in, performs an overwrite of the underlying shared block and
> > causes the associated data corruption.
> 
> Can you write this in the form of an xfstests reproducer please? :)
> 

I'll add it to the todo list.

Brian

> -Eric
