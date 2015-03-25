Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A9D57F51
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 01:05:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07A578F8092
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 23:05:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	hFFCUX62pg0SdE7T for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 23:05:55 -0700 (PDT)
Date: Wed, 25 Mar 2015 17:05:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 1/12] fs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Message-ID: <20150325060552.GY28621@dastard>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
	<1424533554-28024-2-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424533554-28024-2-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Sun, Feb 22, 2015 at 12:45:43AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> FALLOC_FL_INSERT_RANGE command is the opposite command of
> FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
> add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
> for writing new data within a file after shifting extents to right as given
> length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
> that is block boundary and use ftruncate(2) for crosses EOF.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Folks, I have merged this into the xfs tree for the 4.1 merge
window. It is under the stable branch "fallocate-insert-range"
in the tree here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

an dis currently included in the for-next branch that is included in
the linux-next tree. I have not included the ext4 kernel support
patch in this branch (patch 3) because I have not seen any reviews
from ext4 developers for it.

Ted, if you want to include that patch in you ext4 tree, feel free
to base it on the above branch, or if you give your  sob or
reviewed-by ok I can pull it into my tree. I'll leave it up to you
to determine how you want to deal with this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
