Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9414A8042
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 09:17:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C68C8F8037
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 07:17:51 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id k9ZCKuYy56uMkQSh for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 07:17:50 -0800 (PST)
Message-ID: <5134BB1F.4020207@sandeen.net>
Date: Mon, 04 Mar 2013 09:17:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<5131283F.8030704@sandeen.net> <20130301223116.GE23616@dastard>
	<51312C73.5060203@sandeen.net>
	<CANU9nT=ALsO3gegWP8vfmYO=CzgPPTRewAfZPYn_en-c2T8ayA@mail.gmail.com>
In-Reply-To: <CANU9nT=ALsO3gegWP8vfmYO=CzgPPTRewAfZPYn_en-c2T8ayA@mail.gmail.com>
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

On 3/4/13 6:47 AM, Ole Tange wrote:
> On Fri, Mar 1, 2013 at 11:32 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> Ole, you can xfs_mdrestore your metadump image and run test repairs on the result,
>> if you want a more realistic "dry run" of what repair would do.
> 
> I have never run xfs_mdrestore before.
> 
> From the man page:
> 
>        xfs_mdrestore should not be used to restore metadata onto an
> existing filesystem unless you are completely certain the  target  can
>  be destroyed.
> 
> It is unclear to me if you are suggesting me to do:
> 
>   xfs_mdrestore the-already-created-dump /dev/md5p1

no. definitely not. :)

> followed by xfs_repair. Or if you want me to restore the metadata on
> another 100 TB partition (I do not have that available).

Nope - to a sparse file, on a filesystem which can hold a file with
100T offsets - like xfs.

> Maybe you have a trick so that it can be restored on some smaller
> block device, so I do not need the 100 TB partition, but I will still
> be able to see how many files are being removed? If you have such a
> trick, consider including it in the manual.

Probably worth doing, or putting in the xfs faq.

Basically, if you do:

# xfs_mdatadump -o /dev/whatever metadump.file
# xfs_mdrestore metadump.file xfsfile.img

or

# xfs_metadump -o /dev/whatever - | xfs_mdrestore - xfsfile.img

then you can xfs_repair xfsfile.img, without the -n, see what happens,
mount the image as loopback, see what's changed, etc, to see what
xfs_repair really would do with your actual filesystem.

(although, if things are so badly corrupted that metadump gets confused,
it's not as good a test).

The metadump only contains *metadata* so if you read any file on
the mounted loopback image, you just get 0s back.

> Also I would love if xfs_repair had an option to copy the changed
> sectors to a file, so it would be easy to revert. E.g:
> 
>   xfs_repair --backup backup.file /dev/sda1
> 
> and if the repair did not work out, then you could revert using:
> 
>   xfs_repair --revert backup.file /dev/sda1
> 
> and be back at your starting state.

That would be nice.  But as soon as you have mounted the result
and made any change at all to the fs, reverting in this manner wouldn't be
safe anymore.

-Eric

> 
> /Ole
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
