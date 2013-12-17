Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 717E429DF8
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:23:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA186AC002
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:23:30 -0800 (PST)
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	dCvFcA0BTt01rjHB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 14:23:29 -0800 (PST)
Received: by mail-ie0-f171.google.com with SMTP id ar20so9331365iec.30
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:23:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387318722-3050-12-git-send-email-jayr@google.com>
References: <1387318722-3050-1-git-send-email-jayr@google.com>
	<1387318722-3050-12-git-send-email-jayr@google.com>
Date: Tue, 17 Dec 2013 14:23:29 -0800
Message-ID: <CAFA30n_xMjUpENFjcbKJQky_rMS_KG=jLLOV1_Dr9ByJ9JSfnA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] xfstests: check if filesystem supports chattr
From: Junho Ryu <jayr@google.com>
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
To: xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Hugh Dickins <hughd@google.com>, Boris Ranto <branto@redhat.com>, Junho Ryu <jayr@google.com>

Hi Christoph,

I'm not sure what you meant by "it might be worth to have a common
_require_chattr helper chared with generic/079". I cannot find
"chattr" in "generic/079".

Regards,
Junho

On Tue, Dec 17, 2013 at 2:18 PM, Junho Ryu <jayr@google.com> wrote:
> Add _require_chattr which verifies exit code of chattr command and call
> it before running generic/277.
>
> Signed-off-by: Junho Ryu <jayr@google.com>
> ---
>
> v2: extracted from patch 9
>
>  common/attr       | 13 +++++++++++++
>  tests/generic/277 |  2 ++
>  2 files changed, 15 insertions(+)
>
> diff --git a/common/attr b/common/attr
> index 4a3ac9e..278633f 100644
> --- a/common/attr
> +++ b/common/attr
> @@ -218,5 +218,18 @@ else # Assume max ~1 block of attrs
>  fi
>
>  export MAX_ATTRVAL_SIZE
> +
> +_require_chattr()
> +{
> +    touch $TEST_DIR/syscalltest
> +    chattr +A $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
> +    if [ $? -ne 0 ]; then
> +      _notrun "chattr has failed to change attribute of a file in TEST_DIR"
> +    fi
> +    cat $TEST_DIR/syscalltest.out >> $seqres.full
> +
> +    rm -f $TEST_DIR/syscalltest.out
> +}
> +
>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/generic/277 b/tests/generic/277
> index 8461ad9..c31f7c4 100755
> --- a/tests/generic/277
> +++ b/tests/generic/277
> @@ -38,11 +38,13 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> +. ./common/attr
>
>  # real QA test starts here
>  _supported_fs generic
>  _supported_os Linux
>  _require_scratch
> +_require_chattr
>
>  _scratch_mkfs > /dev/null 2>&1
>  _scratch_mount
> --
> 1.8.5.1
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
