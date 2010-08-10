Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7ADhmQx091090 for <xfs@oss.sgi.com>; Tue, 10 Aug 2010 08:43:49 -0500
Received: from CGYSNEX001.encana.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CAB614C9114
	for <xfs@oss.sgi.com>; Tue, 10 Aug 2010 06:52:48 -0700 (PDT)
Received: from CGYSNEX001.encana.com (cgysnex001.encana.com [142.56.87.68]) by
	cuda.sgi.com with ESMTP id rRtHDWz5dj5aUGvg for
	<xfs@oss.sgi.com>; Tue, 10 Aug 2010 06:52:48 -0700 (PDT)
Received: from CGYEX202.encana.com (unverified) by CGYSNEX001.encana.com
	(Clearswift SMTPRS 5.3.2) with ESMTP id
	<T97675da1988e3857444b4@CGYSNEX001.encana.com> for <xfs@oss.sgi.com>;
	Tue, 10 Aug 2010 07:44:11 -0600
Received: from CGYEX710.encana.com (unverified) by CGYEX202.encana.com
	(Clearswift SMTPRS 5.3.2) with ESMTP id
	<T97675da0c08e38c91315c8@CGYEX202.encana.com> for <xfs@oss.sgi.com>;
	Tue, 10 Aug 2010 07:44:10 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfstests: fix NIS detection damage
Date: Tue, 10 Aug 2010 07:44:10 -0600
Message-ID: <F57F2AD357626644AF76410876025D75529750@CGYEX705.encana.com>
In-Reply-To: <1281057519-24730-1-git-send-email-david@fromorbit.com>
References: <1281057519-24730-1-git-send-email-david@fromorbit.com>
From: "Kinzel, David" <David.Kinzel@encana.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dave Chinner <dchinner@redhat.com> said,
>
>NIS detection wasn't tested on machines without NIS enabled, 
>so many tests are
>failing on non-NIS machines. the _yp_active function has no 
>specific return
>value so always evaluates as 0 (active) and the "_cat_passwd" 
>function is
>called from within an awk script which is not valid as the 
>shell may run with a
>sanitised environment. Hence the functions do not need 
>specific export calls,
>either, as unsanitised subshells will automatically inherit 
>the parent's
>environment.
>

Is there any reason why getent passwd/group cannot be used for these, as
it would get local and nss defined accounts? This would add support for
people using LDAP as well.


>Signed-off-by: Dave Chinner <dchinner@redhat.com>
>---
> common.attr |    9 +++++++--
> common.rc   |    6 +++---
> 2 files changed, 10 insertions(+), 5 deletions(-)
>
>diff --git a/common.attr b/common.attr
>index 51616bc..6ba0b32 100644
>--- a/common.attr
>+++ b/common.attr
>@@ -90,10 +90,14 @@ _create_n_aces()
> #
> _filter_aces()
> {
>-    $AWK_PROG '
>+    tmp_file=`mktemp /tmp/ace.XXXXXX`
>+
>+    (_cat_passwd; _cat_group) > $tmp_file
>+
>+    $AWK_PROG -v tmpfile=$tmp_file '
> 	BEGIN {
> 	    FS=":"
>-	    while ( "_cat_passwd" | getline > 0 ) {
>+	    while ( getline <tmpfile > 0 ) {
> 		idlist[$1] = $3 
> 	    }
> 	}
>@@ -102,6 +106,7 @@ _filter_aces()
> 	/^default:user/ { if ($3 in idlist) sub($3, 
>idlist[$3]); print; next}
> 	{print}
>     '
>+    rm -f $tmp_file
> }
> 
> _filter_aces_notypes()
>diff --git a/common.rc b/common.rc
>index e0cdfe6..08d4f71 100644
>--- a/common.rc
>+++ b/common.rc
>@@ -800,13 +800,14 @@ _yp_active()
> 	local dn
> 	dn=$(domainname 2>/dev/null)
> 	test -n "${dn}" -a "${dn}" != "(none)"
>+	echo $?
> }
> 
> # cat the password file
> #
> _cat_passwd()
> {
>-	[ _yp_active ] && ypcat passwd
>+	[ $(_yp_active) -eq 0 ] && ypcat passwd
> 	cat /etc/passwd
> }
> 
>@@ -814,10 +815,9 @@ _cat_passwd()
> #
> _cat_group()
> {
>-	[ _yp_active ] && ypcat group
>+	[ $(_yp_active) -eq 0 ] && ypcat group
> 	cat /etc/group
> }
>-export -f _yp_active _cat_passwd _cat_group
> 
> # check for the fsgqa user on the machine
> #
>-- 
>1.7.1
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs
>

This email communication and any files transmitted with it may contain confidential and or proprietary information and is provided for the use of the intended recipient only.  Any review, retransmission or dissemination of this information by anyone other than the intended recipient is prohibited.  If you receive this email in error, please contact the sender and delete this communication and any copies immediately.  Thank you.
http://www.encana.com



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
