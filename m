Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36892 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750970AbcKCT5C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Nov 2016 15:57:02 -0400
Subject: Re: Can I add external log device after filesystem was created?
References: <CACNifpV5z3r0WB3xypSfGxk6E-=b+3TWrsS4Od7+bKwmmD3yeA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1e60fac5-f2b9-3903-c18c-0a73d0206e0a@sandeen.net>
Date: Thu, 3 Nov 2016 14:57:01 -0500
MIME-Version: 1.0
In-Reply-To: <CACNifpV5z3r0WB3xypSfGxk6E-=b+3TWrsS4Od7+bKwmmD3yeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marcin Sura <mailing-lists@sura.pl>, linux-xfs@vger.kernel.org

On 11/3/16 2:28 PM, Marcin Sura wrote:
> Hi,
> 
> I've created filesystem with default mkfs.xfs command, started to use
> the filesystem. Few days later I've got nice SSD-based lun which can
> be used as external log device.
> 
> Can I add that lun as external log device to an existing filesystem? How?
> 
> BR
> Marcin

There is no supported mechanism for doing this.  It can be done with xfs_db
disk-editing surgery, but that's not really recommended.

What is your reason for wanting to move the log?

-Eric
