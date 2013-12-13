Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 052287F4E
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 22:07:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E79A78F8052
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 20:07:06 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9U72XBBQBiGqOZj6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 20:06:58 -0800 (PST)
Message-ID: <52AA87B6.6010607@oracle.com>
Date: Fri, 13 Dec 2013 12:06:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: set umask to avoid spurious generic/314 test
	failures
References: <20130921211735.GC7855@wallace>
In-Reply-To: <20130921211735.GC7855@wallace>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org

Hi Folks,

We missed this patch from Eric for a few months, I observed the same
false alarm while analyzing xfstests logs against our next tree...

Eric's fix works fine to me.

Thanks,
-Jeff

On 09/22 2013 05:17 AM, Eric Whitney wrote:
> Generic/314 can fail when the group write file mode bit for "subdir" does not
> match that found in the golden output, as has been seen in ext4 regression
> testing.  It appears that the golden output for generic/314 was taken on a
> system where the $qa_user's umask cleared that mode bit - most likely, where
> the umask was 022.  Depending upon the distro, it's not uncommon for a user's
> default umask to have a different value, such as 002.  When that's the case,
> we get a false negative failure when the group write mode bit for "subdir" is
> not cleared.  This failure is unrelated to the value of the SGID mode bit
> that is the object of this test.
> 
> We could either require that $qa_user's account be configured in advance with
> a umask of 022, or explicitly set a umask value compatible with the golden
> output when creating "subdir".  The latter option is more robust.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  tests/generic/314 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>  mode change 100644 => 100755 tests/generic/314
> 
> diff --git a/tests/generic/314 b/tests/generic/314
> old mode 100644
> new mode 100755
> index 0dd98a3..f430b82
> --- a/tests/generic/314
> +++ b/tests/generic/314
> @@ -57,7 +57,7 @@ chown $qa_user:12345 $TEST_DIR/$seq-dir
>  chmod 2775 $TEST_DIR/$seq-dir
>  
>  # Make subdirs before & after acl set
> -su $qa_user -c "mkdir $TEST_DIR/$seq-dir/subdir"
> +su $qa_user -c "umask 022; mkdir $TEST_DIR/$seq-dir/subdir"
>  su $qa_user -c "setfacl -m u:$qa_user:rwx,d:u:$qa_user:rwx $TEST_DIR/$seq-dir"
>  su $qa_user -c "mkdir $TEST_DIR/$seq-dir/subdir2"
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
