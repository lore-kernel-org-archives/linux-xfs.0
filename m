Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 17:43:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9M0gMAS019900
	for <linux-xfs@oss.sgi.com>; Sun, 21 Oct 2007 17:42:24 -0700
Date: Mon, 22 Oct 2007 10:42:25 +1000
Subject: Re: can't remove dir
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net> <20071017161504.GA13077@apartia.fr> <20071017212434.GB995458@sgi.com> <20071018131116.GA11957@apartia.fr> <20071018220714.GM995458@sgi.com> <20071019101008.GA28175@apartia.fr> <20071021235052.GV995458@sgi.com>
Message-ID: <op.t0kpkzft3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20071021235052.GV995458@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, linux-xfs@oss.sgi.com, Louis-David Mitterrand <vindex+lists-xfs@apartia.org>

On Mon, 22 Oct 2007 09:50:52 +1000, David Chinner <dgc@sgi.com> wrote:

> On Fri, Oct 19, 2007 at 12:10:08PM +0200, Louis-David Mitterrand wrote:
>> On Fri, Oct 19, 2007 at 08:07:14AM +1000, David Chinner wrote:
>> > On Thu, Oct 18, 2007 at 03:11:16PM +0200, Louis-David Mitterrand  
>> wrote:
>> > > On Thu, Oct 18, 2007 at 07:24:39AM +1000, David Chinner wrote:
>> > > > On Wed, Oct 17, 2007 at 06:15:04PM +0200, Louis-David Mitterrand  
>> wrote:
>> > > > > Using a 2.6.23 kernel and after a clean xfs_repair-2.9.4 run I  
>> can't
>> > > > > remove that file:
>> > > > >
>> > > > > sylla:/# rm /lost+found/3912672557
>> > > > > rm: cannot remove `/lost+found/3912672557': Operation not  
>> permitted
>> > > > >
>> > > > > sylla:/# ls -li /lost+found/3912672557
>> > > > > 3912672557 lrwxrwxrwx 1 root root 9 2006-04-09 19:10  
>> /lost+found/3912672557 -> unix.7.gz
>> > > >
>> > > > Can you post the output of:
>> > > >
>> > > > # xfs_db -r -c "inode 3912672557" -c "p" <device>
>> > >
>> > > Here:
>> > >
>> > > core.magic = 0x494e
>> > > core.mode = 0120777
>> > > core.version = 1
>> > > core.format = 1 (local)
>> > > core.nlinkv1 = 1
>> > .....
>> > > core.immutable = 1
>> >   ^^^^^^^^^^^^^^^^^^
>> >
>> > You can't remove this link until you remove the immutable flag.
>> >
>> > # xfs_io -r -c "chattr -i" /lost+found/3912672557
>>
>> sylla:~# xfs_io -r -c "chattr -i" /lost+found/3912672557
>> /lost+found/3912672557: No such file or directory
>
> Strange. This implies that lookup can't find inode # 3912672557.
> We know it is there...
>
> How many other files in the directory? Can you get the inode number
> for the lost+found directory and dump that with xfs_db (as per above)?
>
> Also, what happens if you "touch /lost+found/unix.7.gz" and try again?
>
> Cheers,
>
> Dave.

Being a symbolic link, xfs_io follows them rather than operates on
them directory.

This will probably require xfs_db magic with the unmounted filesystem:

# xfs_db -x -c "inode 3912672557" -c "write core.immutable 0" <device>

Barry.
