From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: About reflink len = 0 behavior
Message-ID: <bedcb76a-4deb-bc0e-7a50-350a8a8db86f@cn.fujitsu.com>
Date: Thu, 20 Oct 2016 15:46:50 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <xfs.oss.sgi.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

Hi Darrick, xfs guys and btrfs guys.

Although such question is quite late as reflink generic tests are in 
fstests for a long time, I'm still not sure what's the correct behavior 
for reflink len = 0.

Test case generic/182 is causing different output between btrfs and xfs.

For btrfs, dedupe will just return 0 and check nothing, while for xfs 
len == 0 means to check the whole file length.

Both makes sense for me, for btrfs len = 0 behavior, it just follows 
read/write functions.
And I assume xfs follows reflink behavior, when len is not specified, 
then reflink the length of src file.

But since it's a generic test, we need to unify the behavior.

So, which one is the standard and which document should we follow for 
such behavior definition?

Thanks,
Qu
