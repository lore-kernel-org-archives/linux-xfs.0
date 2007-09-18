Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 20:02:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8I32Muw023089
	for <linux-xfs@oss.sgi.com>; Mon, 17 Sep 2007 20:02:27 -0700
Date: Tue, 18 Sep 2007 12:43:05 +1000
Subject: Re: can't remove dir
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <20070914080926.GA30150@apartia.fr> <Pine.LNX.4.64.0709140438130.752@p34.internal.lan> <20070914084125.GA31074@apartia.fr> <20070914091032.GE734179@sgi.com> <20070914092712.GA31997@apartia.fr>
Message-ID: <op.tytwh3tl3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20070914092712.GA31997@apartia.fr>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>, linux-xfs@oss.sgi.com

On Fri, 14 Sep 2007 19:27:21 +1000, Louis-David Mitterrand  
<vindex+lists-xfs@apartia.org> wrote:

> On Fri, Sep 14, 2007 at 07:10:32PM +1000, David Chinner wrote:
>>
>> Also, get the inode number of the bad directory (ls -i) and then
>> run:
>>
>> # xfs_db -r -c "inode <inode_num>" -c "p" <device of fs>
>
> sylla:/lost+found# xfs_db -r -c "inode 1879629858" -c "p" /dev/md1
> core.magic = 0x494e
> core.mode = 040755
> core.version = 1
> core.format = 2 (extents)
> core.nlinkv1 = 2
> core.uid = 0
> core.gid = 0
> core.flushiter = 9
> core.atime.sec = Tue Aug  1 20:49:16 2006
> core.atime.nsec = 000000000
> core.mtime.sec = Fri Sep 14 09:25:29 2007
> core.mtime.nsec = 589593557
> core.ctime.sec = Fri Sep 14 09:25:29 2007
> core.ctime.nsec = 589593557
> core.size = 8192
> core.nblocks = 3
> core.extsize = 0
> core.nextents = 2
> core.naextents = 0
> core.forkoff = 0
> core.aformat = 2 (extents)
> core.dmevmask = 0
> core.dmstate = 0
> core.newrtbm = 0
> core.prealloc = 0
> core.realtime = 0
> core.immutable = 0
> core.append = 0
> core.sync = 0
> core.noatime = 0
> core.nodump = 0
> core.rtinherit = 0
> core.projinherit = 0
> core.nosymlinks = 0
> core.extsz = 0
> core.extszinherit = 0
> core.nodefrag = 0
> core.gen = 0
> next_unlinked = null
> u.bmx[0-1] = [startoff,startblock,blockcount,extentflag]  
> 0:[0,117476868,2,0] 1:[8388608,125865476,1,0]
>

If you still have the bad directory, can you run these as well?

# xfs_db -r -c "inode 1879629858" -c "dblock 0" -c "p" /dev/md1
# xfs_db -r -c "inode 1879629858" -c "dblock 1" -c "p" /dev/md1
# xfs_db -r -c "inode 1879629858" -c "dblock 8388608" -c "p" /dev/md1

Thanks,
Barry.
