Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 14:45:12 -0700 (PDT)
Received: from smtp102.sbc.mail.re2.yahoo.com (smtp102.sbc.mail.re2.yahoo.com [68.142.229.103])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5RLj7tL011852
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 14:45:08 -0700
Date: Wed, 27 Jun 2007 14:45:06 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: After reboot fs with barrier faster deletes then fs with nobarrier
Message-ID: <20070627214506.GA1352@tuatara.stupidest.org>
References: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Szabolcs Illes <S.Illes@westminster.ac.uk>
Cc: xfs@oss.sgi.com

On Wed, Jun 27, 2007 at 06:58:29PM +0100, Szabolcs Illes wrote:

> I repeated this test several times, same results. I made sure
> nothing was running while I was doing the tests, cpu was idle, hdd
> led was not on, etc.

instead of doing a reboot can you try something like:

    echo 1 > /proc/sys/vm/drop_caches

or
    echo 3 > /proc/sys/vm/drop_caches

(the value is a bit mask, bit 0 will drop the page cache, bit 1 will
drop the slab)

does that give you more or less the same results as rebooting?




another thing to try, before the delete, also try:

    find path/to/whatever -noleaf >/dev/null

and see if that helps (i expect it should greatly)
