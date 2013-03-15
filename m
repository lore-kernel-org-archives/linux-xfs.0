Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9929F8035
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 11:03:08 -0500 (CDT)
Message-ID: <51434653.40808@sgi.com>
Date: Fri, 15 Mar 2013 11:03:31 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: make defrag test 222 generic
References: <513F5B0A.4030405@redhat.com> <20130315145540.GG7229@twin.jikos.cz>
In-Reply-To: <20130315145540.GG7229@twin.jikos.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On 03/15/2013 09:55 AM, David Sterba wrote:
> On Tue, Mar 12, 2013 at 11:42:50AM -0500, Eric Sandeen wrote:
>> Define a new _defrag_dir() helper which just runs noisy/debug
>> dir defrag for ext4 and/or btrfs as well, and use that in 222
>> instead of hardcoded xfs_fsr.
>
> Dir defrag on btrfs does not recurse in the given directory to defrag
> all files, but defragments the tree of the containing subvolume and the
> whole extent tree (thus needs CAP_SYS_ADMIN).
>
> This is known (and not very intuitive) behaviour, it would be better to
> add a special parameter to defrag the root and/or the extent root and
> pass it down to the ioctl via flags.
>
> Until this is implemented I suggest to use a workaround via 'find':
>
>   find $dir -print -execdir $DEFRAG_PROG '{}' +
>
> Otherwise the test looks ok.
>
> david

Eric, I will make this change at commit time if you agree?

David, can I put your name as the reviewer when I do?

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
