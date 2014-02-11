Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A04A7F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 13:01:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B7708F806F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 11:01:18 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id iPHdF4oAHkjNjbcJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 11:01:14 -0800 (PST)
Message-ID: <52FA7374.2000209@oracle.com>
Date: Tue, 11 Feb 2014 20:01:08 +0100
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: Btrfs: add test for large metadata blocks
References: <1392068362-14049-1-git-send-email-koen.de.wit@oracle.com>
	<20140210220400.GV13647@dastard>
In-Reply-To: <20140210220400.GV13647@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6905559259632128873=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============6905559259632128873==
Content-Type: multipart/alternative;
 boundary="------------060601040306060204000006"

This is a multi-part message in MIME format.
--------------060601040306060204000006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2014 11:04 PM, Dave Chinner wrote:
> On Mon, Feb 10, 2014 at 10:39:22PM +0100, Koen De Wit wrote:
>> +
>> +_test_illegal_leafsize() {
>> +        _scratch_mkfs -l $1 >>$seqres.full 2>&1
>> +        [ $? -ne 0 ] || _fail "'$1' is an illegal value for the" \
>> +                "leafsize option, mkfs should have failed."
>> +}
> You just re-implemented run_check....

I believe I didn't :

    run_check()
    {
             echo "# $@" >> $seqres.full 2>&1
             "$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
    }

run_check() takes an arbitrary command and executes it, _test_illegal_leafsize() takes a leafsize as parameter and tries mkfs.btrfs with that leafsize. run_check() makes the test fail if the return code is not zero, _test_illegal_leafsize() does the opposite.

Thanks,
Koen.

--------------060601040306060204000006
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    On 02/10/2014 11:04 PM, Dave Chinner wrote:<br>
    <blockquote cite="mid:20140210220400.GV13647@dastard" type="cite">
      <pre wrap="">On Mon, Feb 10, 2014 at 10:39:22PM +0100, Koen De Wit wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">+
+_test_illegal_leafsize() {
+        _scratch_mkfs -l $1 &gt;&gt;$seqres.full 2&gt;&amp;1
+        [ $? -ne 0 ] || _fail "'$1' is an illegal value for the" \
+                "leafsize option, mkfs should have failed."
+}
</pre>
      </blockquote>
      <pre wrap="">
You just re-implemented run_check....
</pre>
    </blockquote>
    <br>
    I believe I didn't :<br>
    <blockquote>run_check()<br>
      {<br>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; echo "# $@" &gt;&gt; $seqres.full 2&gt;&amp;1<br>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "$@" &gt;&gt; $seqres.full 2&gt;&amp;1 || _fail "failed:
      '$@'"<br>
      }<br>
    </blockquote>
    run_check() takes an arbitrary command and executes it,
    _test_illegal_leafsize() takes a leafsize as parameter and tries
    mkfs.btrfs with that leafsize. run_check() makes the test fail if
    the return code is not zero, _test_illegal_leafsize() does the
    opposite.<br>
    <br>
    Thanks,<br>
    Koen.<br>
  </body>
</html>

--------------060601040306060204000006--


--===============6905559259632128873==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6905559259632128873==--
