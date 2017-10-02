Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42170 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751065AbdJBOMs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Oct 2017 10:12:48 -0400
Subject: Re: Suggested XFS setup/options for 10TB file system w/ 18-20M files.
References: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
 <fb88053a-873d-92f9-198d-ee8d4f841658@sandeen.net>
 <8066DE0B-5CC2-4B64-ACC1-4EA1462B450A@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e1900b8b-db65-dc0f-338c-a56d12de3e90@sandeen.net>
Date: Mon, 2 Oct 2017 09:12:47 -0500
MIME-Version: 1.0
In-Reply-To: <8066DE0B-5CC2-4B64-ACC1-4EA1462B450A@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "R. Jason Adams" <rjasonadams@gmail.com>
Cc: linux-xfs@vger.kernel.org

On 10/2/17 8:49 AM, R. Jason Adams wrote:
>> On what version of kernel & what version of xfsprogs?
> 
> We’re on CentOS 7: 
> 
> 3.10.0-693.2.2.el7.x86_64
> xfsprogs.x86_64  4.5.0-12.el7

Ok.  At least we know inode64 is on by default.

>>> The application opens the file, writes the data (single call), and closes the file. In addition there are a few lines added to the extended attributes. The filesystem ends up with 18 to 20 million files when the drive is full. The files are currently spread over 128x128 directories using a hash of the filename.
>>
>> It's not uncommon for application filename hashing like this to be less efficient than the internal xfs directory algorithms, FWIW.
> 
> Good to know. We originally had 256x256 and changed to 128x128 to see if it would help. I figured 18M files in 1 directory wasn’t ideal though.

I'd suggest figuring less, testing more.  Maybe, maybe not.

> 
>>> The format command I'm using:
>>>
>>> mkfs.xfs -f -i size=1024 ${DRIVE}
>>
>> Why 1k inodes?
> 
> Our extended attributes average ~200B .. figured a little extra room wouldn’t hurt?
Don't figure, measure... ;)

> 
> Example:
> 
> getfattr -d 3c75666a3279623367406b79633479346c777a2e6c706f7471696e3e
> 
> # file: 3c75666a3279623367406b79633479346c777a2e6c706f7471696e3e
> user.offset="682"
> user.crc="1911595230"
> user.date="1506918540"
> user.id="f97800a5-66cd-4cb1-9a95-796ae0e8871e"
> user.inserted="1506918595"
> user.size="793169"

That example fits in a default 512 byte inode
without trouble, FWIW:

$ getfattr -d file
# file: file
user.crc="1911595230"
user.date="1506918540"
user.id="f97800a5-66cd-4cb1-9a95-796ae0e8871e"
user.offset="682"
user.size="793169"

$ xfs_bmap -a file
file: no extents

If you have larger than needed inodes, that's some
amount of unnecessary overhead right there.
> 
>>> Mount options:
>>>
>>> rw,noatime,attr2,inode64,allocsize=2048k,logbufs=8,logbsize=256k,noquota
>>
>> Why all these options?
> 
> Started with defaults.. started adding options trying to resolve the issue ;)

Ok, too much shooting from the hip.  Most of those are defaults already...
unless you have a specific reason to change defaults, generally best
not to try random things without understanding.
 
> 
>> Perhaps it's taking time reading through a large custom-hashed directory tree?  I don't know what that custom directory layout might look like.
> 
> It’s currently 128 dirs, each with 128 in them.
> 
> 
>> Have you tried starting with defaults, and working your way up from there (if needed?)
> 
> Yep. I’m so used to XFS “just working” that I started trying a lot of
> options after searching for solutions. Lots of suggestions out there.
> ;)

Yeah, everybody's an expert.  ;)

If you want to figure out where your reads are coming from, you could use
blktrace to get the read locations, and use xfs_db to work your way back
to what metadata is being read.  Or, possibly using tracepoints would be
enlightening.  

...now I'm going to break my own rule and make a suggestion without 
sufficient analysis;
if you're allocating a lot of inodes, turning on the free inode btree at
mkfs time might help (mkfs.xfs -m finobt=1)

-Eric

> 
> -R. Jason Adams

