Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB2027F54
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 10:46:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B2F2AC002
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 08:46:15 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fs7HuMFL6w9z7HXQ for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 08:46:13 -0800 (PST)
Message-ID: <5130DB54.9030503@sandeen.net>
Date: Fri, 01 Mar 2013 10:46:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<512FA67D.2090708@sandeen.net>
	<CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
In-Reply-To: <CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ole Tange <tange@binf.ku.dk>
Cc: xfs@oss.sgi.com

On 3/1/13 3:37 AM, Ole Tange wrote:
> On Thu, Feb 28, 2013 at 7:48 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 2/28/13 9:22 AM, Ole Tange wrote:
> 
>>> /usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
> [...]
>>> Segmentation fault (core dumped)
>>>
>>> Core put in: http://dna.ku.dk/~tange/tmp/xfs_repair.core.bz2
>>
>> We'd need a binary w/ debug symbols to go along with it.
> 
> http://dna.ku.dk/~tange/tmp/xfs_repair
> 
>> an xfs_metadump might recreate the problem too.
> 
> # sudo ./xfs_metadump.sh -g /dev/md5p1 - | pbzip2 >
> /home/tange/public_html/tmp/metadump.bz2
> xfs_metadump: cannot init perag data (117)
> Copying log

I'll take a look.  May be that the error renders it
invalid but we'll see.

> http://dna.ku.dk/~tange/tmp/metadump.bz2
> 
> Please consider providing an example in the man page for xfs_metadump e.g:
> 
>   xfs_metadump.sh -g /dev/sda2 meta.dump

>From the manpage,

SYNOPSIS
       xfs_metadump [ -efgow ] [ -l logdev ] source target

The source argument must be the pathname of
the device or file containing the XFS filesystem

and

the target argument specifies the destination file name. 

is not enough?

Thanks,
-Eric

> 
> /Ole
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
