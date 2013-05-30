Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38CFC7F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 03:07:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9E91AC003
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 01:07:23 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id aQw7oLMEpb4HrhNG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 01:07:19 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4U87IBx003195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 08:07:19 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4U87HBa001854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 08:07:18 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4U87HsX006277 for <xfs@oss.sgi.com>; Thu, 30 May 2013 08:07:17 GMT
Message-ID: <51A708B2.2080701@oracle.com>
Date: Thu, 30 May 2013 12:07:14 +0400
From: alexander.tsvetkov@oracle.com
MIME-Version: 1.0
Subject: XFStest suite problem
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
To: xfs@oss.sgi.com

Hello,

There is a problem found in XFS tests suite: attempt to run XFS tests 
with some tests excluded from run, for example, "./check -g auto -X 231" 
causes the unexpected exclusion of some other tests (for example 
generic/127 in this case). Looking into suite's created exclude list 
indicates that it was incorrectly built by including some garbage 
together with correct test numbers records, so /tmp/30535.xlist looks like:

"generic/#!
generic//bin/bash
generic/#
generic/FSQA
generic/Test
generic/No.
generic/231
generic/#
generic/#
generic/Run
generic/fsx
generic/with
generic/quotas
generic/enabled
generic/and
generic/verify
generic/accounted
generic/quotas
generic/in
generic/the
generic/end
generic/#
generic/#
generic/Derived
generic/from
generic/test
generic/127
generic/#-----------------------------------------------------------------------
generic/#
generic/Copyright
generic/(c)
generic/2006
generic/Silicon
generic/Graphics,
..."

I think the following code of "check" script incorrectly builds this 
exclude list:

"-X) xfile=$2; shift ;
for d in $SRC_GROUPS $FSTYP; do
[ -f $SRC_DIR/$d/$xfile ] || continue
for f in `cat $SRC_DIR/$d/$xfile`; do
echo $d/$f >> $tmp.xlist
done
done
;;"

Used XFStests suite version from 2013-05-22.

Thanks,
Alexander Tsvetkov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
