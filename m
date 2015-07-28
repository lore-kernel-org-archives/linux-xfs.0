Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CEABB7F6B
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 11:53:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC7728F8050
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 09:53:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6AlCJ3e4ZG6DV0vg for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2015 09:53:35 -0700 (PDT)
Message-ID: <55B7B390.1050206@sandeen.net>
Date: Tue, 28 Jul 2015 09:53:36 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net>
	<20150720111747.GA53450@bfoster.bfoster>
	<55B73365.1050908@mygrande.net>
	<20150728123307.GC38784@bfoster.bfoster>
	<55B79BFD.6020509@mygrande.net>
In-Reply-To: <55B79BFD.6020509@mygrande.net>
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
To: Leslie Rhorer <lrhorer@mygrande.net>, Brian Foster <bfoster@redhat.com>
Cc: Kris Rusocki <kszysiu@braxis.org>, "Rhorer,
	Leslie" <Leslie.Rhorer@level3.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/28/15 8:13 AM, Leslie Rhorer wrote:
> On 7/28/2015 7:33 AM, Brian Foster wrote:
>> On Tue, Jul 28, 2015 at 02:46:45AM -0500, Leslie Rhorer wrote:
>>> On 7/20/2015 6:17 AM, Brian Foster wrote:
>>>> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:

...

>>>> would try to hopefully isolate a filesystem problem from something
>>>> underneath:
>>>>
>>>> xfs_metadump -go /dev/md0 /somewhere/on/rootfs/md0.metadump
>>>> xfs_mdrestore -g /somewhere/on/rootfs/md0.metadump /.../fileonrootfs.img
>>>> mount /.../fileonrootfs.img /mnt/
>>>
>>>     I tried to do the xfs_mdrestore to the root file system, but it fails:
>>>
>>> RAID-Server:/TEST# xfs_mdrestore -g md0.metadump RAIDfile.img
>>> xfs_mdrestore: cannot set filesystem image size: File too large
>>>
>>
>> Hmm, I guess the file size exceeds the capabilities of the root fs, even
>> if there might ultimately be enough space to restore the metadump.
> 
> I wouldn't think so, at least not fundamentally. It's ext4. It's
> certainly not big enough to hold an 18T file system, though, and
> perhaps that is what xfs_restore is checking.

No, it's just failing to write any data at an 18T offset.

The ext4 filesystem (with 4k blocks) is limited to a 16T maximum file
offset; you won't be able to restore a (sparse) 18T filesystem
image onto an ext4 filesystem.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
