Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Oct 2007 17:34:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9O0YAEZ001938
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2007 17:34:12 -0700
Date: Wed, 24 Oct 2007 10:34:15 +1000
Subject: Re: [RFC 0/2] Case-insensitive filename lookup for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
References: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com> <200710231422.21637.ms@teamix.de>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t0oejdbf3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <200710231422.21637.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <ms@teamix.de>, xfs@oss.sgi.com

On Tue, 23 Oct 2007 22:22:21 +1000, Martin Steigerwald <ms@teamix.de> wrote:

> Am Dienstag, 23. Oktober 2007 schrieb Barry Naujok:
>
> Hi Barry,
>
>> To allow case-insensitivity to be a mount option rather than
>> a mkfs option, the hashes stored on disk are always case-folded.
>> This is indicated by the new "unicode" bit in the superblock.
>> This bit also associated with the presence of the case-folding
>> table on disk.
>
> What would happen in the following scenario?
>
> mount -t xfs /dev/somedevice /mnt/tmp
> touch /mnt/tmp/testfile
> touch /mnt/tmp/Testfile
> touch /mnt/tmp/TESTFILE
>
> mount -t xfs -o remount,ci /dev/somedevice /mnt/tmp
> rm /mnt/tmp/testfile

testfile would be deleted, Testfile and TESTFILE will remain.
Subsequent rm's should remove the rest.
