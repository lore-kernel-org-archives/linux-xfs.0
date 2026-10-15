Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015A8261B8D;
	Thu, 15 Oct 2026 00:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025491; cv=none; b=Vv4VaXWyRRULMx90lhhwmYWOwrQs/ozF3KpypE+SJhDd2FxDnBbyIKDt96/HLFsc6RpCAvTCWdya8PaVn93YGiBsLWVU4ToQ2HFJHTA3yrLq0TyDHConGOyqkwAeEB0Q97O94f71IIabJyW+a/wDD4xBIvfKjVoFQ/bbYs8gr4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025491; c=relaxed/simple;
	bh=5Ct28oe446RN1duwTWZbR/BZyQwiLClzoiqI4MTq87c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eMpMsn/itR1gg7cTD5amn0ckE69/InZmg0T4JzNpteHO2Omu82La9IbLAbXiOU8Kt7R37TDp33t3KaiutXtHyB9lMu0pU5lwynVzWv1EqXABFW88hlz+6AxMkbCzSamR3YLlR6JNB+UEdvD5hCQckLzjUb4V5YEeyG4ldjbGy4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hq3xP0Pf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hq3xP0Pf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6DA821F000C4;
	Thu, 15 Oct 2026 00:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792025486;
	bh=gyJG4VeaL6KWsdjtZisUpACfUE0FQqfBmodTXdJ9pLk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hq3xP0PfJv9v7OB4FFYt1UTZBwQkdTygBxSaZN0K3XUql2E6R7VrcjF6VxUrPHXp4
	 lxILn9FQe2dim/c8SQHKwi/kUVew8/cgEhaHsiEEr5rGqjqJsD73T7B2e/QYeEAPcH
	 iTwRmwrRPi2ZZkqH6TzmgTquRawwL+zKgjD5BOPJKV5Qv5lod7JFIoe6Wr8MC65xSM
	 d1bwsdOBjuR1Lrd+aM70v+jlh/cETt7JGSE/wc9liLvoekOpqH4/wrEcpEtZA4iqT+
	 9MpJDELUaWm4Icf5tf8ssyqQlNj/MAqEgQeNYkj6QJr6R2t8R2Aw84ZXqb8CigCd/u
	 wT3urxEH881aQ==
Date: Wed, 14 Oct 2026 17:51:26 -0700
Subject: [PATCH 1/6] matrix: add test result database code
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, tytso@mit.edu, fstests@vger.kernel.org
Message-ID: <179202481200.3448668.3121835002890442954.stgit@frogsfrogsfrogs>
In-Reply-To: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
References: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add the schema files and scripts necessary to create and manage a sqlite
database full of fstests results.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 matrix/database/archive.in             |   86 ++
 matrix/database/create_db.in           |   28 +
 matrix/database/create_views.in        |   26 +
 matrix/database/database.sql           |  123 +++
 matrix/database/db.in                  |   27 +
 matrix/database/find_new_tarballs      |   47 +
 matrix/database/fstestdb.py            | 1147 ++++++++++++++++++++++++++++++++
 matrix/database/index.sql              |   27 +
 matrix/database/query_all_test_runs.in |  334 +++++++++
 matrix/database/query_checktime        |   31 +
 matrix/database/query_machines.in      |   41 +
 matrix/database/query_test_run.in      |   38 +
 matrix/database/stow_tarball           |  169 +++++
 matrix/database/stow_tarballs          |   34 +
 matrix/database/test_runtime           |    9 
 matrix/database/upsert_test_run.in     |  448 ++++++++++++
 matrix/database/views.sql              |   89 ++
 17 files changed, 2704 insertions(+)
 create mode 100755 matrix/database/archive.in
 create mode 100755 matrix/database/create_db.in
 create mode 100755 matrix/database/create_views.in
 create mode 100644 matrix/database/database.sql
 create mode 100755 matrix/database/db.in
 create mode 100755 matrix/database/find_new_tarballs
 create mode 100644 matrix/database/fstestdb.py
 create mode 100644 matrix/database/index.sql
 create mode 100755 matrix/database/query_all_test_runs.in
 create mode 100755 matrix/database/query_checktime
 create mode 100755 matrix/database/query_machines.in
 create mode 100755 matrix/database/query_test_run.in
 create mode 100755 matrix/database/stow_tarball
 create mode 100755 matrix/database/stow_tarballs
 create mode 100755 matrix/database/test_runtime
 create mode 100755 matrix/database/upsert_test_run.in
 create mode 100644 matrix/database/views.sql


diff --git a/matrix/database/archive.in b/matrix/database/archive.in
new file mode 100755
index 00000000000000..6842b2ef802fbd
--- /dev/null
+++ b/matrix/database/archive.in
@@ -0,0 +1,86 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Archive test artifacts
+# Usage: $0 [--rm] fsmatrix-dir [urlprefix]
+
+srcdir="$(dirname "$0")"
+keep=1
+fsmatrix=
+urlprefix=
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+print_help() {
+	echo "Archive test artifacts in a tarball."
+	echo "Usage: $0 [--rm] database_dir [urlprefix]"
+}
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	print_help
+	exit 1
+fi
+
+for arg in "$@"; do
+	case "${arg}" in
+	"--rm")
+		keep=
+		;;
+	"--help"|-*)
+		print_help
+		exit 1
+		;;
+	*)
+		if [ -z "${fsmatrix}" ]; then
+			fsmatrix="${arg}"
+		elif [ -z "${urlprefix}" ]; then
+			urlprefix="${arg}"
+		else
+			echo "${arg}: database dir and url prefix already specified"
+			print_help
+			exit 1
+		fi
+		;;
+	esac
+done
+
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+
+cd "${fsmatrix}"
+
+# Compress the test artifacts into a tarball.
+if [ ! -e "artifacts.tar.zst" ]; then
+	# Why does redirecting the output instead of using -o result in a
+	# smaller file?
+	tar c fingerprints/ groups/ machines/ | \
+		zstd -19 -T0 -v > artifacts.tar.zst || exit
+
+	test -z "${keep}" && rm -r -f fingerprints groups machines
+fi
+
+# Regenerate json and rss feeds if we were given a url prefix (aka the
+# dashboard is present)
+if [ -n "${urlprefix}" ] && [ -x "%pkg_libexec_dir%/create_dashboard" ]; then
+	webdir="$(readlink -m "${fsmatrix}/../www/")"
+
+	"%pkg_libexec_dir%/create_dashboard" "${fsmatrix}" "${webdir}"
+
+	# Last new results that were visible
+	"${srcdir}/query_recent_test_runs" \
+		--json "${webdir}/fstestsbot.js" \
+		--rss  "${webdir}/fstestsbot.rss" \
+		--urlprefix "${urlprefix}" \
+		"${fsmatrix}"
+
+	# Giant catalogue of everything
+	"${srcdir}/query_all_test_runs" \
+		--json "${webdir}/fstestsall.js" \
+		--rss  "${webdir}/fstestsall.rss" \
+		--urlprefix "${urlprefix}" \
+		--compress \
+		"${fsmatrix}"
+fi
diff --git a/matrix/database/create_db.in b/matrix/database/create_db.in
new file mode 100755
index 00000000000000..4e6af959cd4d39
--- /dev/null
+++ b/matrix/database/create_db.in
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Create database
+# Usage: $0 fsmatrix-dir
+
+srcdir="$(dirname "$0")"
+sqldir="%pkg_lib_dir%"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+if [ $# -ne 1 ] || [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Initialize database with schema and views."
+	echo "Usage: $0 database_dir"
+	exit 1
+fi
+
+fsmatrix="$1"
+mkdir -p "${fsmatrix}"
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+
+"${srcdir}/db" "${fsmatrix}" < "${sqldir}/database.sql"
+"${srcdir}/db" "${fsmatrix}" < "${sqldir}/index.sql"
+"${srcdir}/db" "${fsmatrix}" < "${sqldir}/views.sql"
diff --git a/matrix/database/create_views.in b/matrix/database/create_views.in
new file mode 100755
index 00000000000000..c8ac4507dd5f0a
--- /dev/null
+++ b/matrix/database/create_views.in
@@ -0,0 +1,26 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Create database views
+# Usage: $0 fsmatrix-dir
+
+srcdir="$(dirname "$0")"
+sqldir="%pkg_lib_dir%"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+if [ $# -ne 1 ] || [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Recreate views in database."
+	echo "Usage: $0 database_dir"
+	exit 1
+fi
+
+fsmatrix="$1"
+mkdir -p "${fsmatrix}"
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+
+"${srcdir}/db" "${fsmatrix}" < "${sqldir}/views.sql"
diff --git a/matrix/database/database.sql b/matrix/database/database.sql
new file mode 100644
index 00000000000000..653227b6d3294e
--- /dev/null
+++ b/matrix/database/database.sql
@@ -0,0 +1,123 @@
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * Copyright (C) 2019-2026 Oracle.
+ *
+ * Main database schema for fstests results.
+ */
+DROP TABLE IF EXISTS hash;
+DROP TABLE IF EXISTS machine;
+DROP TABLE IF EXISTS machine_name;
+DROP TABLE IF EXISTS test;
+DROP TABLE IF EXISTS test_name;
+DROP TABLE IF EXISTS test_run;
+DROP TABLE IF EXISTS result_type;
+DROP TABLE IF EXISTS result;
+
+PRAGMA foreign_keys = ON;
+
+CREATE TABLE hash(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	value		TEXT UNIQUE NOT NULL,
+	mtime		DATE NOT NULL
+);
+CREATE TABLE machine(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	hash_id		INTEGER NOT NULL,
+	arch		TEXT NOT NULL,
+	ram_mb		INTEGER NOT NULL,
+	cpus		INTEGER NOT NULL,
+	nodes		INTEGER NOT NULL,
+	nr_disk		INTEGER NOT NULL,
+	disk_mb		INTEGER NOT NULL,
+	nr_pmem		INTEGER NOT NULL,
+	pmem_mb		INTEGER NOT NULL,
+	mtime		DATE NOT NULL,
+
+	FOREIGN KEY(hash_id)		REFERENCES hash(id)
+);
+CREATE TABLE machine_name(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	name		TEXT UNIQUE NOT NULL,
+	machine_id	INTEGER NOT NULL,
+	mtime		DATE NOT NULL,
+
+	FOREIGN KEY(machine_id)		REFERENCES machine(id)
+);
+CREATE TABLE test_run(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	hash_id		INTEGER NOT NULL,
+	machine_id	INTEGER NOT NULL,
+	machine_name_id	INTEGER NOT NULL,
+	start_time	DATE NOT NULL,
+	mtime		DATE NOT NULL,
+	fstyp		TEXT NOT NULL,
+	kernel		TEXT,
+	mount_opts	TEXT,
+	mkfs_opts	TEXT,
+	check_opts	TEXT,
+	time_factor	INTEGER,
+	load_factor	INTEGER,
+	test_dir	TEXT,
+	test_dev	TEXT,
+	scratch_mnt	TEXT,
+	scratch_dev	TEXT,
+	section		TEXT,
+	run_time	INTEGER,
+	failed		INTEGER NOT NULL,
+	skipped		INTEGER NOT NULL,
+	tried		INTEGER NOT NULL,
+	counted		INTEGER NOT NULL,
+
+	FOREIGN KEY(hash_id)		REFERENCES hash(id)
+	FOREIGN KEY(machine_id)		REFERENCES machine(id)
+	FOREIGN KEY(machine_name_id)	REFERENCES machine_name(id)
+);
+CREATE TABLE test(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	hash_id		INTEGER NOT NULL,
+	mtime		DATE NOT NULL,
+
+	FOREIGN KEY(hash_id)		REFERENCES hash(id)
+);
+CREATE TABLE test_name(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	name		TEXT UNIQUE NOT NULL,
+	test_id		INTEGER NOT NULL,
+	mtime		DATE NOT NULL,
+
+	FOREIGN KEY(test_id)		REFERENCES test(id)
+);
+CREATE TABLE groups(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	name		TEXT UNIQUE NOT NULL,
+	mtime		DATE NOT NULL
+);
+CREATE TABLE test_group(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	test_id		INTEGER NOT NULL,
+	group_id	INTEGER NOT NULL,
+	mtime		DATE NOT NULL,
+
+	FOREIGN KEY(test_id)		REFERENCES test(id)
+	FOREIGN KEY(group_id)		REFERENCES groups(id)
+);
+CREATE TABLE result_type(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	name		TEXT UNIQUE NOT NULL,
+	mtime		DATE NOT NULL
+);
+CREATE TABLE result(
+	id		INTEGER PRIMARY KEY NOT NULL,
+	test_run_id	INTEGER NOT NULL,
+	test_id		INTEGER NOT NULL,
+	result_type_id	INTEGER NOT NULL,
+	runtime		INTEGER NOT NULL,
+	has_diff	BOOLEAN NOT NULL,
+	has_full	BOOLEAN NOT NULL,
+	has_dmesg	BOOLEAN NOT NULL,
+	mtime		DATE NOT NULL,
+
+	FOREIGN KEY(test_run_id)	REFERENCES test_run(id),
+	FOREIGN KEY(test_id)		REFERENCES test(id),
+	FOREIGN KEY(result_type_id)	REFERENCES result_type(id)
+);
diff --git a/matrix/database/db.in b/matrix/database/db.in
new file mode 100755
index 00000000000000..29d16bb6225363
--- /dev/null
+++ b/matrix/database/db.in
@@ -0,0 +1,27 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Query database
+# Usage: $0 fsmatrix-dir
+
+srcdir="$(dirname "$0")"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+if [ $# -eq 0 ] || [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Open database with sqlite extensions."
+	echo "Usage: $0 database_dir [sqlite_args]"
+	exit 1
+fi
+
+fsmatrix="$1"
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+shift
+
+fsmatrix="$(readlink -m "${fsmatrix}")"
+database="${fsmatrix}/fstests.db"
+exec sqlite3 "$@" "${database}"
diff --git a/matrix/database/find_new_tarballs b/matrix/database/find_new_tarballs
new file mode 100755
index 00000000000000..0a120df13fd066
--- /dev/null
+++ b/matrix/database/find_new_tarballs
@@ -0,0 +1,47 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Find the new tarballs
+# Usage: $0 tarball-dir
+
+srcdir="$(readlink -m "$(dirname "$0")")"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+if [ $# -ne 1 ] || [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Print a list of files in a directory which are newer than the directory catalog file."
+	echo "Usage: $0 tarball_dir"
+	exit 1
+fi
+
+tarballs="$1"
+catalog="tarballs.list"
+test -d "${tarballs}" || die "tarball dir not present"
+
+cd "${tarballs}"
+
+# Update our finder timestamp
+touch .find_new
+
+# Generate the list of tarballs modified since the last finder timestamp
+newer=()
+test -e "${catalog}" && newer=('-newer' "${catalog}")
+find . "${newer[@]}" -type f \( -name '*.tar.xz' -print0 -o \
+				-name '*.tar.gz' -print0 -o \
+				-name '*.tar.zst' -print0 \) | \
+	xargs -0 stat -c '%Y|%n' 2> /dev/null | \
+	sort -g > "${catalog}.new"
+mv "${catalog}.new" "${catalog}"
+
+# Change the catalog timestamp to match the finder timestamp.  This is to
+# avoid concurrency problems if tarballs get updated after the find command
+# traverses a tarball's directory entry but doesn't finish writing until at
+# least one more timestamp quantum passes.
+touch -r .find_new "${catalog}"
+
+cat "${catalog}"
+exit 0
diff --git a/matrix/database/fstestdb.py b/matrix/database/fstestdb.py
new file mode 100644
index 00000000000000..4b6f0caab43ef8
--- /dev/null
+++ b/matrix/database/fstestdb.py
@@ -0,0 +1,1147 @@
+#! /usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Object library for fstests test result objects
+
+import os
+import sqlite3
+import sys
+import tokenize
+import io
+import fcntl
+import copy
+import time
+
+# Set debugging info
+if 'DBG' in os.environ:
+	try:
+		DEBUG = int(os.environ['DBG'])
+	except:
+		DEBUG = 1
+else:
+	DEBUG = 0
+
+UPD_UPDATE = 1
+UPD_INSERT = 2
+
+def sqlite_dict_factory(cursor, row):
+	d = {}
+	for idx, col in enumerate(cursor.description):
+		d[col[0]] = row[idx]
+	return d
+
+class Database(object):
+	'''Wrapper for database objects.'''
+	def __init__(self, fsmatrix_dir, readonly = True):
+		dbfile = f'{fsmatrix_dir}/fstests.db'
+		self.fd = open(dbfile)
+
+		# sqlite sucks at concurrency, so we use flock locks to ensure
+		# that only one program accesses the db at a time
+		if readonly:
+			fcntl.flock(self.fd, fcntl.LOCK_SH)
+			db = f'file:{dbfile}?mode=ro'
+		else:
+			fcntl.flock(self.fd, fcntl.LOCK_EX)
+			db = f'file:{dbfile}?mode=rwc'
+
+		self.conn = sqlite3.connect(db, uri = True)
+		self.conn.row_factory = sqlite_dict_factory
+
+		# Use the write ahead log, which also sets synchronous = NORMAL
+		if not readonly:
+			self.conn.execute('PRAGMA journal_mode = WAL')
+
+		# 2GB of mmap memory or cache
+		self.conn.execute('PRAGMA mmap_size = 2147483648')
+		self.conn.execute('PRAGMA cache_size = -2097152')
+		self.in_update = False
+
+	def __del__(self):
+		self.conn.close()
+		fcntl.flock(self.fd, fcntl.LOCK_UN)
+		self.fd.close()
+
+	def dirty(self):
+		return self.in_update
+
+	def try_begin_update(self):
+		if not self.in_update:
+			self.begin_update()
+
+	def begin_update(self):
+		assert not self.in_update
+
+		self.conn.execute('BEGIN TRANSACTION')
+		self.in_update = True
+
+	def cancel_update(self):
+		assert self.in_update
+
+		self.conn.execute('ROLLBACK TRANSACTION')
+		self.in_update = False
+
+	def commit_update(self):
+		assert self.in_update
+
+		self.conn.execute('COMMIT TRANSACTION')
+		self.conn.commit()
+		self.in_update = False
+
+	def __execute(self, sql, values = ()):
+		if DEBUG:
+			print(sql, values)
+		return self.conn.execute(sql, values)
+
+	def __needs_update(self, sql, values):
+		'''Does this object need to be inserted, updated, or nothing?'''
+		cur = self.__execute(sql, values)
+		if cur.fetchone() == None:
+			return UPD_INSERT
+		return UPD_UPDATE
+
+	def fetch(self, table, attrs, object_keys):
+		'''Return a dictionary for this object's database attrs.'''
+		#assert len(attrs & set(object_keys)) == len(object_keys)
+
+		where_criteria = []
+		where_values = []
+
+		#SELECT attr1, attr2 FROM table
+		# WHERE
+		#	(key1 = ?)
+
+		for k in object_keys:
+			where_criteria.append('(%s = ?)' % k)
+			where_values.append(object_keys[k])
+		
+		if DEBUG > 1:
+			print('table', table)
+			print('wc', where_criteria)
+			print('wv', where_values)
+
+		# Create the SELECT statement for fetch
+		sql = 'SELECT %s FROM %s WHERE %s' % \
+				(', '.join(attrs), table, ' AND '.join(where_criteria))
+		cur = self.__execute(sql, where_values)
+
+		# Return the (unique?) result
+		ret = cur.fetchone()
+		assert cur.fetchone() == None
+		return ret
+
+	def upsert(self, table, dictionary, object_keys, mtime_key, db_key):
+		'''Make sure the db @table contains a row for @dictionary '''
+		'''with the given @object_keys and a modification time kept '''
+		'''in @mtime_key.'''
+		assert len(set(dictionary) & object_keys) == len(object_keys)
+		assert mtime_key not in object_keys
+		assert self.in_update
+
+		if DEBUG > 1:
+			print(('starting an upsert', table, dictionary,
+				object_keys, mtime_key, db_key))
+
+		mtime = dictionary[mtime_key]
+		attrs = list(set(dictionary) - object_keys)
+
+		insert_attrs = ', '.join(attrs + list(object_keys))
+		insert_values = []
+		update_setters = []
+		where_criteria = []
+		set_values = []
+		where_values = []
+
+		def obj_key(o):
+			for field in o.fields:
+				if o.fields[field].object_key:
+					return field
+			assert False
+
+		# These are the SQL statements we're trying to construct:
+
+		# Fast update if we already have a key
+		#UPDATE table SET
+		#	(attr1 = ?,
+		#	attr2 = (SELECT id FROM table3 WHERE hash = ?))
+		# WHERE
+		#	(id = ?)
+		for db_attr in db_key:
+			for k in attrs:
+				obj = dictionary[k]
+				if not isinstance(obj, DatabaseObject):
+					update_setters.append('%s = ?' % k)
+					set_values.append(obj)
+					continue
+				ok = obj_key(obj)
+				vstr = '(SELECT %s FROM %s WHERE %s = ?)' % \
+						(obj.db_key, obj.table_name, ok)
+				update_setters.append('%s = %s' % (k, vstr))
+
+				key = getattr(obj, ok)
+				if not isinstance(key, DatabaseObject):
+					set_values.append(key)
+					continue
+
+				value = getattr(key, key.db_key)
+				set_values.append(value)
+
+			# Create the UPDATE statement for objects that do exist
+			sql = 'UPDATE %s SET %s WHERE %s = ?' % \
+					(table, ', '.join(update_setters), db_attr)
+			set_values.append(db_key[db_attr])
+			values = tuple(set_values)
+			self.__execute(sql, values)
+			return
+
+		# Figure out if there's already an object in the table
+		#SELECT mtime FROM table
+		# WHERE
+		#	(key1 = ?) AND
+		#	(key2 = (SELECT id FROM table2 WHERE hash = ?))
+
+		# Insert new object into table
+		#INSERT INTO table
+		#	(attr1, attr2, key1, key2)
+		# VALUES
+		#	(?,
+		#	(SELECT id FROM table3 WHERE hash = ?),
+		#	?,
+		#	?)
+
+		# Update object if we don't have a key
+		#UPDATE table SET
+		#	(attr1 = ?,
+		#	attr2 = (SELECT id FROM table3 WHERE hash = ?))
+		# WHERE
+		#	(key1 = ?) AND
+		#	(key2 = (SELECT id FROM table2 WHERE hash = ?))
+
+		# Non-keys go first because they can be changed at any time
+		for k in attrs:
+			obj = dictionary[k]
+			if not isinstance(obj, DatabaseObject):
+				insert_values.append('?')
+				update_setters.append('%s = ?' % k)
+				set_values.append(obj)
+				continue
+			ok = obj_key(obj)
+			vstr = '(SELECT %s FROM %s WHERE %s = ?)' % \
+					(obj.db_key, obj.table_name, ok)
+			insert_values.append(vstr)
+			update_setters.append('%s = %s' % (k, vstr))
+
+			key = getattr(obj, ok)
+			if not isinstance(key, DatabaseObject):
+				set_values.append(key)
+				continue
+
+			value = getattr(key, key.db_key)
+			set_values.append(value)
+
+		# Record keys go last so that we can put the WHERE clause at
+		# the end.
+		for k in object_keys:
+			obj = dictionary[k]
+			if not isinstance(obj, DatabaseObject):
+				insert_values.append('?')
+				where_criteria.append('(%s = ?)' % k)
+				where_values.append(obj)
+				continue
+			ok = obj_key(obj)
+			vstr = '(SELECT %s FROM %s WHERE %s = ?)' % \
+					(obj.db_key, obj.table_name, ok)
+			insert_values.append(vstr)
+			where_criteria.append('(%s = %s)' % (k, vstr))
+
+			key = getattr(obj, ok)
+			if not isinstance(key, DatabaseObject):
+				where_values.append(key)
+				continue
+
+			value = getattr(key, key.db_key)
+			where_values.append(value)
+
+		if DEBUG > 1:
+			print('mtime_key', mtime_key)
+			print('table', table)
+			print('ia', insert_attrs)
+			print('iv', insert_values)
+			print('us', update_setters)
+			print('wc', where_criteria)
+			print('sv', set_values)
+			print('wv', where_values)
+
+		# Create the SELECT statement for if-modified-since
+		status_sql = 'SELECT %s FROM %s WHERE %s' % \
+				(mtime_key, table, ' AND '.join(where_criteria))
+
+		# Create the INSERT statment for objects that don't exist
+		insert_sql = 'INSERT INTO %s (%s) VALUES (%s)' % \
+				(table, insert_attrs, ', '.join(insert_values))
+
+		# Create the UPDATE statement for objects that do exist
+		update_sql = 'UPDATE %s SET %s WHERE %s' % \
+				(table, ', '.join(update_setters), \
+				 ' AND '.join(where_criteria))
+
+		# Figure out what our action is going to be, and do it
+		upd = self.__needs_update(status_sql, tuple(where_values))
+		if upd == UPD_INSERT:
+			sql = insert_sql
+		else:
+			sql = update_sql
+		values = tuple(set_values + where_values)
+		self.__execute(sql, values)
+
+class DatabaseObjectField(object):
+	'''Attribute of an object.'''
+	def __init__(self, type, default = None, object_key = False, optional = False):
+		assert default is None or isinstance(default, type)
+
+		self.type = type
+		self.default = default
+		self.object_key = object_key
+		self.optional = optional and not object_key
+
+	def sql(self, value):
+		'''Return the value ready for sql upload.'''
+		return None if value is None else self.type(value)
+
+fld = DatabaseObjectField
+
+class DatabaseObjectRelation(DatabaseObjectField):
+	'''Relation between objects.'''
+	def __init__(self, type, object_key = False):
+		super().__init__(type, None, object_key)
+
+	def sql(self, value):
+		'''Return the value ready for sql upload.'''
+		assert value is not None
+		assert isinstance(value, self.type)
+		assert isinstance(value, DatabaseObject)
+
+		return value
+
+rel = DatabaseObjectRelation
+
+class DatabaseObject(object):
+	'''Base class of database objects.'''
+	db_key = 'id'
+	obj_mtime = 'mtime'
+	def __init__(self, **kwargs):
+		'''Initialize an object with given attributes.'''
+		assert hasattr(self, 'fields')
+		assert hasattr(self, 'table_name')
+		assert len([x for x in self.fields if self.fields[x].object_key]) > 0
+
+		setattr(self, type(self).db_key, None)
+		self.dirty = False
+		relations = set([x for x in self.fields if isinstance(x, DatabaseObjectRelation)])
+
+		# Complain about unrecognized attributes
+		leftovers = set(kwargs) - set(self.fields)
+		if len(leftovers) != 0:
+			print(kwargs)
+			print(self.fields)
+			print(relations)
+			print(leftovers)
+			assert len(leftovers) == 0
+
+		# Internal db primary key shouldn't be an attr
+		assert self.db_key not in self.fields
+
+		# mtime must be a non-relation attribute
+		assert self.obj_mtime in self.fields
+
+		for a in self.fields:
+			v = kwargs[a] if a in kwargs else self.fields[a].default
+			setattr(self, a, v)
+
+		for a in relations:
+			# Relations must be set at construction time
+			assert hasattr(self, a)
+
+	def needs_update(self, timestamp):
+		'''Return true if the timestamp is newer than the object mtime.'''
+		obj_mtime = getattr(self, self.obj_mtime, None)
+		if obj_mtime is None:
+			return True
+		return obj_mtime < timestamp
+
+	def obj_key(self):
+		'''Return a tuple that can be used to identify this object.'''
+
+		obj_key = []
+		for field in self.fields:
+			if self.fields[field].object_key:
+				obj = getattr(self, field)
+				if isinstance(obj, DatabaseObject):
+					value = getattr(obj, obj.db_key)
+					obj_key.append(value)
+				else:
+					obj_key.append(obj)
+		return tuple(obj_key)
+
+	def assert_formed(self):
+		'''Is this object fully specified?'''
+		for name in self.fields:
+			field = self.fields[name]
+
+			obj = getattr(self, name, None)
+			if isinstance(field, DatabaseObjectRelation):
+				# relations are always required
+				if obj is None:
+					raise Exception(f'{self}.{name} relation is None')
+				obj.assert_formed()
+			elif not field.optional and obj is None:
+				raise Exception(f'{self}.{name} is None')
+		return True
+
+	def reconnect(self, db):
+		'''Connect an object with related objects.'''
+
+		for name in self.fields:
+			field = self.fields[name]
+
+			if not isinstance(field, DatabaseObjectRelation):
+				continue
+
+			obj = getattr(self, name)
+			if obj is None:
+				continue
+			try:
+				obj.assert_formed()
+				continue
+			except:
+				pass
+
+			# Substitute this object for one in the object manager
+			# if such a thing exists.
+			ret = ObjectManager.find_object(obj)
+			if ret is None:
+				ObjectManager.store_object(obj)
+			elif ret != obj:
+				obj = ret
+				# connect to existing object
+				setattr(self, name, ret)
+			obj.reconnect(db)
+
+	def persist(self, db):
+		'''Persist this object and its children to the database.'''
+		self.reconnect(db)
+
+		for name in self.fields:
+			field = self.fields[name]
+
+			if not isinstance(field, DatabaseObjectRelation):
+				continue
+
+			obj = getattr(self, name)
+			assert obj is not None
+			obj.persist(db)
+
+		self.upsert(db)
+
+	def db_keys(self):
+		'''Return a dictionary of this object's database keys.'''
+		obj_keys = {}
+		for x in self.fields:
+			if self.fields[x].object_key:
+				obj = getattr(self, x)
+				if isinstance(obj, DatabaseObject):
+					obj_keys[x] = getattr(obj, obj.db_key)
+				else:
+					obj_keys[x] = obj
+		return obj_keys
+
+	def get_db_id(self, db):
+		'''Fetch this object's db table id.'''
+		assert getattr(self, self.db_key, None) == None
+
+		obj_keys = self.db_keys()
+		attrs = db.fetch(self.table_name, [self.db_key], obj_keys)
+		if attrs is None:
+			return
+		setattr(self, self.db_key, attrs[self.db_key])
+		return attrs[self.db_key]
+
+	def fetch(self, db, raw_id = None):
+		'''Fetch this object's attributes from the database.'''
+		fetch_fields = copy.copy(self.fields)
+		fetch_fields[self.db_key] = fld(int)
+
+		if raw_id is not None:
+			# Deserialize based on a table id
+			obj_keys = {self.db_key: raw_id}
+		else:
+			# Create a dictionary of the primary keys & values
+			obj_keys = self.db_keys()
+
+		attrs = db.fetch(self.table_name, set(fetch_fields), obj_keys)
+		if attrs is None:
+			return
+
+		setattr(self, self.db_key, attrs[self.db_key])
+
+		# Populate the object.  We had better get all the fields...
+		for name in self.fields:
+			field = self.fields[name]
+
+			if not isinstance(field, DatabaseObjectRelation):
+				setattr(self, name, attrs[name])
+				continue
+
+			# Construct a template object and see if we already
+			# have one registered.
+			template = field.type()
+			template.fetch(db, attrs[name])
+			obj = ObjectManager.find_object(template)
+			if obj is None:
+				# Nothing registered; store this unconnected
+				# prototype
+				ObjectManager.store_object(template)
+				obj = template
+			setattr(self, name, obj)
+
+		self.dirty = False
+
+	@classmethod
+	def resurrect(cls, db, **kwargs):
+		'''Resurrect a database object from key data.'''
+
+		template = cls(**kwargs)
+		ret = ObjectManager.find_object(template)
+		if ret is not None:
+			ret.reconnect(db)
+			return ret
+		else:
+			ret = template
+			ret.fetch(db)
+			ObjectManager.store_object(ret)
+		ret.reconnect(db)
+		return ret
+
+	@classmethod
+	def predicate(cls, field, op, value):
+		'''Convenience method to construct field predicates.'''
+		return FieldPredicate(cls, field, op, value)
+
+class MutableDatabaseObject(DatabaseObject):
+	'''Mutable database object.'''
+
+	def map_vars(self):
+		'''Default function to map SQL attributes to object fields, '''
+		'''assuming attributes and fields have the same name.'''
+		r = {}
+		for d in self.fields:
+			o = getattr(self, d)
+			r[d] = self.fields[d].sql(o)
+		return r
+
+	def upsert(self, db):
+		'''Make sure this object exists in the database.'''
+		self.assert_formed()
+
+		if not self.dirty:
+			return
+
+		db_val = getattr(self, self.db_key)
+		if db_val is not None:
+			db_key = {self.db_key: db_val}
+		else:
+			db_key = {}
+
+		obj_keys = set([x for x in self.fields if self.fields[x].object_key])
+		db.upsert(self.table_name, self.map_vars(), obj_keys, \
+				self.obj_mtime, db_key)
+		self.dirty = False
+		if db_val is None:
+			self.get_db_id(db)
+
+	def set_attr(self, name, value):
+		'''Set a value.'''
+		assert name in self.fields
+		assert not isinstance(self.fields[name], DatabaseObjectRelation)
+
+		if not hasattr(self, name):
+			print('%s: attr not found in %s.' % (name, self),
+					file = sys.stderr)
+			assert hasattr(self, name)
+
+		if getattr(self, name, None) != value:
+			self.dirty = True
+		setattr(self, name, value)
+
+	def set_relation(self, name, rel):
+		'''Set a relationship.'''
+		assert name in self.fields
+		assert isinstance(self.fields[name], DatabaseObjectRelation)
+		assert isinstance(rel, self.fields[name].type)
+
+		if getattr(self, name, None) != rel:
+			self.dirty = True
+		setattr(self, name, rel)
+
+	def touch(self, lastmod):
+		'''Set the last modification time.'''
+		self.set_attr(self.obj_mtime, int(lastmod))
+
+class Hash(MutableDatabaseObject):
+	'''Hash string table object.'''
+	table_name = 'hash'
+	fields = {
+		'value':	fld(str, object_key = True),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+class Machine(MutableDatabaseObject):
+	'''Profile of a testing machine configuration.'''
+	table_name = 'machine'
+	fields = {
+		'hash_id':	rel(Hash, object_key = True),
+		'arch':		fld(str),
+		'cpus':		fld(int),
+		'nodes':	fld(int, default = 0),
+		'ram_mb':	fld(int),
+		'nr_pmem':	fld(int, default = 0),
+		'pmem_mb':	fld(int, default = 0),
+		'nr_disk':	fld(int, default = 0),
+		'disk_mb':	fld(int, default = 0),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+	def reset_storage(self):
+		'''Reset the storage counters.'''
+		self.nr_pmem = 0
+		self.pmem_mb = 0
+		self.nr_disk = 0
+		self.disk_mb = 0
+
+	def add_pmem(self, size_mb):
+		'''Add a persistent memory device.'''
+		self.nr_pmem += 1
+		self.pmem_mb += size_mb
+
+	def add_disk(self, size_mb):
+		'''Add a disk device.'''
+		self.nr_disk += 1
+		self.disk_mb += size_mb
+
+	def summarize_storage(self):
+		'''Average the storage amount.'''
+		if self.nr_pmem > 0:
+			self.pmem_mb = int(self.pmem_mb / self.nr_pmem)
+		if self.nr_disk > 0:
+			self.disk_mb = int(self.disk_mb / self.nr_disk)
+
+class MachineName(MutableDatabaseObject):
+	'''Mapping of machine name to machine configuration.'''
+	table_name = 'machine_name'
+	fields = {
+		'machine_id':	rel(Machine),
+		'name':		fld(str, object_key = True),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+class TestRun(MutableDatabaseObject):
+	'''Summary of an invocation of the fstests.'''
+	table_name = 'test_run'
+	fields = {
+		'hash_id':	rel(Hash, object_key = True),
+		'machine_id':	rel(Machine),
+		'machine_name_id': rel(MachineName),
+		'start_time':	fld(int),
+		'mtime':	fld(int),
+		'fstyp':	fld(str),
+		'kernel':	fld(str, optional = True),
+		'mount_opts':	fld(str, optional = True),
+		'mkfs_opts':	fld(str, optional = True),
+		'check_opts':	fld(str, optional = True),
+		'time_factor':	fld(int, default = 1, optional = True),
+		'load_factor':	fld(int, default = 1, optional = True),
+		'test_dir':	fld(str, optional = True),
+		'test_dev':	fld(str, optional = True),
+		'scratch_mnt':	fld(str, optional = True),
+		'scratch_dev':	fld(str, optional = True),
+		'section':	fld(str, optional = True),
+		'run_time':	fld(int, optional = True),
+		'failed':	fld(int),
+		'skipped':	fld(int),
+		'tried':	fld(int),
+		'counted':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+class Test(MutableDatabaseObject):
+	'''Test case.  We identify a test case based on its header comment.'''
+	table_name = 'test'
+	fields = {
+		'hash_id':	rel(Hash, object_key = True),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+class TestName(MutableDatabaseObject):
+	'''Mapping of test name to test case.'''
+	table_name = 'test_name'
+	fields = {
+		'test_id':	rel(Test),
+		'name':		fld(str, object_key = True),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+class Group(MutableDatabaseObject):
+	'''Group of test cases.'''
+	table_name = 'groups'
+	fields = {
+		'name':		fld(str, object_key = True),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		self.members = set()
+		super().__init__(**kwargs)
+
+	def add_member(self, member):
+		'''Add a group member to this group.'''
+		assert member.group == self
+		self.members.add(member)
+
+class GroupMember(MutableDatabaseObject):
+	'''Mapping of group to test case.'''
+	table_name = 'test_group'
+	fields = {
+		'group_id':	rel(Group, object_key = True),
+		'test_id':	rel(Test, object_key = True),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+class ResultType(MutableDatabaseObject):
+	'''Test result type.'''
+	table_name = 'result_type'
+	fields = {
+		'name':		fld(str, object_key = True),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+class Result(MutableDatabaseObject):
+	'''Mapping of test run and test to a result.'''
+	table_name = 'result'
+	fields = {
+		'test_run_id':	rel(TestRun, object_key = True),
+		'test_id':	rel(Test, object_key = True),
+		'result_type_id': rel(ResultType),
+		'runtime':	fld(int, 0),
+		'has_diff':	fld(bool, False),
+		'has_full':	fld(bool, False),
+		'has_dmesg':	fld(bool, False),
+		'mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+class MachineWithName(DatabaseObject):
+	'''Cross product of machine and name.'''
+	table_name = 'machine_with_name'
+	fields = {
+		'hash':		fld(str),
+		'arch':		fld(str),
+		'cpus':		fld(int),
+		'nodes':	fld(int, 0),
+		'ram_mb':	fld(int),
+		'nr_pmem':	fld(int, 0),
+		'pmem_mb':	fld(int, 0),
+		'nr_disk':	fld(int, 0),
+		'disk_mb':	fld(int, 0),
+		'mtime':	fld(int),
+		'name':		fld(str, object_key = True),
+		'name_mtime':	fld(int),
+	}
+	def __init__(self, **kwargs):
+		super().__init__(**kwargs)
+
+# Object Manager...
+class ObjectManager(object):
+	'''Object manager for fstests matrix entities.'''
+	__objects = {}
+	__objects[Machine] = {}
+	__objects[MachineName] = {}
+	__objects[TestRun] = {}
+	__objects[Test] = {}
+	__objects[TestName] = {}
+	__objects[Group] = {}
+	__objects[GroupMember] = {}
+	__objects[ResultType] = {}
+	__objects[Result] = {}
+	__objects[MachineWithName] = {}
+	__objects[Hash] = {}
+
+	@staticmethod
+	def find_object(template):
+		'''Retrieve an object based on a template.'''
+		assert isinstance(template, DatabaseObject)
+
+		try:
+			obj_key = template.obj_key()
+			return ObjectManager.__objects[type(template)][obj_key]
+		except KeyError:
+			return None
+
+	@staticmethod
+	def store_object(template):
+		'''Store an object based on a ... key?'''
+		assert isinstance(template, DatabaseObject)
+
+		obj_key = template.obj_key()
+		ObjectManager.__objects[type(template)][obj_key] = template
+
+	@staticmethod
+	def ensure_object(template):
+		r = find_object(template)
+		if r is not None:
+			return r
+
+		store_object(template)
+		return template
+
+# Query support...
+class Predicate(object):
+	'''Object selector predicate.'''
+	pass
+
+class FieldPredicate(Predicate):
+	'''Object field selector predicate.'''
+	str_ops = set(['=', 'LIKE', '!='])
+	num_ops = set(['=', '<=', '>=', '>', '<', '!='])
+	def __init__(self, objtype, field, op, value):
+		self.objtype = objtype
+		self.field = field
+		self.op = op
+		self.value = value
+		self.check([objtype])
+
+	def check(self, types):
+		'''Check that this predicate makes sense.'''
+		assert self.objtype in types
+		assert self.field in self.objtype.fields
+		if self.objtype.fields[self.field].type is str:
+			assert self.op in self.str_ops
+		else:
+			assert self.op in self.num_ops
+
+	def sql(self, values, need_table_name = False):
+		'''Generate sql for this predicate.'''
+		if need_table_name:
+			field = '%s.%s' % (self.objtype.table_name, self.field)
+		else:
+			field = self.field
+		values.append(self.objtype.fields[self.field].sql(self.value))
+		return '%s %s ?' % (field, self.op)
+
+class PredicateSet(Predicate):
+	'''Base class for a set of boolean predicates.'''
+	def __init__(self, predicates):
+		assert hasattr(self, 'op')
+		self.predicates = predicates
+
+	def check(self, types):
+		'''Ensure that the predicate set makes sense.'''
+		for p in self.predicates:
+			p.check(types)
+
+	def sql(self, values, need_table_name = False):
+		'''Generate sql for these predicates.'''
+		return '(%s)' % self.op.join([x.sql(values, need_table_name) \
+				for x in self.predicates])
+
+	def append(self, pred):
+		'''Append a predicate.'''
+		assert pred is not None
+
+		self.predicates.append(pred)
+
+class OrSet(PredicateSet):
+	op = ' OR '
+
+class AndSet(PredicateSet):
+	op = ' AND '
+
+class DatabaseQuery(object):
+	'''Query the fstests results database.'''
+	def __init__(self, db):
+		self.db = db
+
+	def __execute(self, sql, values = ()):
+		if DEBUG:
+			print(sql, values)
+		return self.db.conn.execute(sql, values)
+
+	def __create_TestRun_from_results(self, results):
+		'''Yield TestRun objects from the query results.'''
+		r = results.fetchone()
+		while r is not None:
+			del r['id']
+			t = TestRun(None, **r)
+			yield t
+			r = results.fetchone()
+
+	def query_test_runs_by_machine_name(self, name, exact = True):
+		'''Query test runs by exact machine name.'''
+		sql = 'SELECT test_run.* FROM test_run, machine_name WHERE ' \
+			'test_run.machine_id = machine_name.machine_id ' \
+			'AND machine_name.name %s ?' % \
+					('=' if exact else 'LIKE')
+		values = (name,)
+		results = self.__execute(sql, values)
+		return self.__create_TestRun_from_results(results)
+
+	def __yield_objects_from_results(self, results, objtype):
+		'''Yield objects from the query results.'''
+		r = results.fetchone()
+		while r is not None:
+			t = objtype(**r)
+			yield t
+			r = results.fetchone()
+
+	def query_single_table(self, objtype, predicates, attrs = None):
+		'''Query a single table or view with the given predicates.'''
+		if attrs is None:
+			column_str = ', '.join([x for x in objtype.fields])
+		else:
+			column_str = ', '.join(attrs)
+		values = []
+		predicates.check([objtype])
+		sql = 'SELECT %s FROM %s WHERE %s' % (column_str, \
+				objtype.table_name, predicates.sql(values))
+		if DEBUG:
+			print((sql, values))
+		results = self.__execute(sql, values)
+		return self.__yield_objects_from_results(results,
+				objtype)
+
+	def query_current_test_runs(self, max_age = None):
+		'''Return the most recent test runs for each machine.'''
+
+		# SELECT machine_name.name, test_run.start_time,
+		# max(test_run.mtime), test_run.kernel, test_run.mount_opts,
+		# test_run.mkfs_opts, test_run.run_time, test_run.failed,
+		# test_run.skipped, test_run.tried, test_run.counted from
+		# test_run, machine_name where machine_name.id =
+		# test_run.machine_name_id group by machine_name_id order by
+		# test_run.mtime;
+
+		values = ()
+		sql = 'SELECT hash.value AS hash, MAX(test_run.mtime) '
+		sql += 'FROM test_run, hash WHERE hash.id = test_run.hash_id '
+		if max_age is not None:
+			sql += 'AND test_run.mtime > ? '
+			values += (int(time.time()) - max_age, )
+		sql += 'GROUP BY test_run.machine_name_id '
+		sql += 'ORDER BY test_run.mtime'
+		rows = self.__execute(sql, values)
+		for row in rows:
+			testrunhash = Hash.resurrect(self.db, value = row['hash'])
+			yield TestRun.resurrect(self.db, hash_id = testrunhash)
+
+	def query_test_runs(self):
+		'''Return all test runs for all machines.'''
+
+		values = ()
+		sql = 'SELECT hash.value AS hash '
+		sql += 'FROM test_run, hash WHERE hash.id = test_run.hash_id '
+		sql += 'ORDER BY test_run.mtime'
+		rows = self.__execute(sql, values)
+		for row in rows:
+			testrunhash = Hash.resurrect(self.db, value = row['hash'])
+			yield TestRun.resurrect(self.db, hash_id = testrunhash)
+
+	def query_failed_tests(self, testrun):
+		'''Return all failed tests for a test run.'''
+
+		result_type = ResultType.resurrect(self.db, name = 'fail')
+
+		sql = 'SELECT hash.value AS hash FROM test, result, hash WHERE result.test_run_id = ? AND result.result_type_id = ? AND test.id = result.test_id AND hash.id = test.hash_id'
+		values = (getattr(testrun, testrun.db_key), getattr(result_type, result_type.db_key))
+		rows = self.__execute(sql, values)
+		for row in rows:
+			testhash = Hash.resurrect(self.db, value = row['hash'])
+			yield Test.resurrect(self.db, hash_id = testhash)
+
+	def query_test_name(self, test):
+		'''Try to return the testname of this test.'''
+		sql = 'SELECT test_name.name FROM test_name, test WHERE test_name.test_id = ?' #test.id AND test.id = ?'
+		values = (getattr(test, test.db_key), )
+		rows = self.__execute(sql, values)
+		for row in rows:
+			yield TestName.resurrect(self.db, name = row['name'])
+
+	@staticmethod
+	def construct_ns_map(objtype):
+		return {
+			objtype.table_name: objtype,
+			None: objtype,
+		}
+
+	@staticmethod
+	def interpret_attrs(attrs, ns_map):
+		'''Construct a list of attributes for a query string.'''
+		def i(tok):
+			nonlocal names, attr_list
+
+			if DEBUG:
+				print(tok)
+			if tok.type == tokenize.NAME:
+				assert len(names) < 2
+				names.append(tok.string)
+			elif tok.type == tokenize.STRING:
+				assert len(names) < 2
+				names.append(tok.string[1:-1])
+			elif tok.type == tokenize.NEWLINE or \
+			     (tok.type == tokenize.OP and tok.string == ',') and \
+			     len(names) > 0:
+				if len(names) > 1:
+					objtype = ns_map[names[0]]
+					field = names[1]
+				else:
+					objtype = ns_map[None]
+					field = names[0]
+				assert field in objtype.fields
+				attr_list.append('.'.join(names))
+				names = []
+		names = []
+		attr_list = []
+		ioh = io.BytesIO(attrs.encode('utf-8'))
+		for tok in tokenize.tokenize(ioh.readline):
+			try:
+				i(tok)
+			except Exception as e:
+				l = tok.end[1] - tok.start[1]
+				c = '%s%s' % (' ' * tok.start[1], '^' * l)
+				whine = 'Error in attribute list before:\n%s\n%s\n%s' % \
+						(attrs, c, '\n'.join(e.args))
+				e.args = [whine]
+				e.tok = tok
+				raise
+		return attr_list
+
+	@staticmethod
+	def interpret_predicates(query, ns_map):
+		'''Construct a set of predicates from a query string.'''
+		def op_ok(op):
+			uop = op.upper()
+			return len(name_parts) > 0 and \
+			     (uop in FieldPredicate.str_ops or \
+			      uop in FieldPredicate.num_ops)
+		def i(tok):
+			nonlocal predicates, name_parts, op, level
+
+			if DEBUG:
+				print(tok)
+			tok_string_lower = tok.string.lower()
+			if tok.type == tokenize.ENCODING or \
+			   tok.type == tokenize.ENDMARKER:
+				return
+			elif tok.type == tokenize.NUMBER or \
+			     tok.type == tokenize.STRING:
+				assert op is not None
+				if DEBUG:
+					print("name ", name_parts, "op ", op,
+							"value ", tok.string)
+				if len(name_parts) == 2:
+					objtype = ns_map[name_parts[0]]
+					field = name_parts[1]
+				else:
+					objtype = ns_map[None]
+					field = name_parts[0]
+				if tok.type == tokenize.STRING:
+					value = tok.string[1:-1]
+				else:
+					value = tok.string
+				pred = objtype.predicate(field, op, value)
+				if predicates[level] is None:
+					predicates[level] = pred
+				else:
+					predicates[level].append(pred)
+				name_parts = []
+				op = None
+			elif tok.type == tokenize.OP and tok.string == '(':
+				level += 1
+				if DEBUG:
+					print("push level %d" % level)
+				predicates.append(None)
+			elif tok.type == tokenize.OP and tok.string == ')':
+				if DEBUG:
+					print("pop level %d" % level)
+				level -= 1
+				if predicates[level] is None:
+					predicates[level] = predicates.pop()
+				else:
+					predicates[level].append(predicates.pop())
+			elif tok.type == tokenize.NAME and \
+			     tok_string_lower == 'and':
+				if DEBUG:
+					print("and ", predicates[level])
+				predicates[level] = AndSet([predicates[level]])
+			elif tok.type == tokenize.NAME and \
+			     tok_string_lower == 'or':
+				if DEBUG:
+					print("or ", predicates[level])
+				predicates[level] = OrSet([predicates[level]])
+			elif tok.type == tokenize.NAME and \
+			     tok_string_lower == 'like' and \
+			     op_ok(tok_string_lower):
+				assert len(name_parts) > 0
+				op = 'LIKE'
+				if DEBUG:
+					print("name ", name_parts, "op ", op)
+			elif tok.type == tokenize.NAME:
+				assert len(name_parts) < 2
+				name_parts.append(tok.string)
+				if DEBUG:
+					print("name ", name_parts)
+			elif tok.type == tokenize.OP and tok.string == '.':
+				assert len(name_parts) == 1
+			elif tok.type == tokenize.OP and \
+			     tok.string == '==' and \
+			     op_ok('='):
+				op = '='
+				if DEBUG:
+					print("name ", name_parts, "op ", op)
+			elif tok.type == tokenize.OP and op_ok(tok.string):
+				op = tok.string
+				if DEBUG:
+					print("name ", name_parts, "op ", op)
+
+		predicates = [None]
+		name_parts = []
+		op = None
+		level = 0
+
+		ioh = io.BytesIO(query.encode('utf-8'))
+		for tok in tokenize.tokenize(ioh.readline):
+			try:
+				i(tok)
+			except BaseException as e:
+				l = tok.end[1] - tok.start[1]
+				c = '%s%s' % (' ' * tok.start[1], '^' * l)
+				whine = 'Error in query before:\n%s\n%s\n%s' % \
+						(query, c, '\n'.join(e.args))
+				e.args = [whine]
+				raise
+		return predicates[0]
+
diff --git a/matrix/database/index.sql b/matrix/database/index.sql
new file mode 100644
index 00000000000000..1601b3fe57b54f
--- /dev/null
+++ b/matrix/database/index.sql
@@ -0,0 +1,27 @@
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * Copyright (C) 2019-2026 Oracle.
+ *
+ * Main index schema for fstests results.
+ */
+DROP INDEX IF EXISTS m_hash;
+DROP INDEX IF EXISTS mn_name;
+DROP INDEX IF EXISTS tr_hash;
+DROP INDEX IF EXISTS t_hash;
+DROP INDEX IF EXISTS tn_name;
+DROP INDEX IF EXISTS g_name;
+DROP INDEX IF EXISTS rt_name;
+DROP INDEX IF EXISTS r_testrunid;
+DROP INDEX IF EXISTS r_testid;
+DROP INDEX IF EXISTS h_hash;
+
+CREATE INDEX h_value ON hash(value);
+CREATE INDEX m_hash ON machine(hash_id);
+CREATE INDEX mn_name ON machine_name(name);
+CREATE INDEX tr_hash ON test_run(hash_id);
+CREATE INDEX t_hash ON test(hash_id);
+CREATE INDEX tn_name ON test_name(name);
+CREATE INDEX g_name ON groups(name);
+CREATE INDEX rt_name ON result_type(name);
+CREATE INDEX r_testrunid ON result(test_run_id);
+CREATE INDEX r_testid ON result(test_id);
diff --git a/matrix/database/query_all_test_runs.in b/matrix/database/query_all_test_runs.in
new file mode 100755
index 00000000000000..649e29ba4c0a43
--- /dev/null
+++ b/matrix/database/query_all_test_runs.in
@@ -0,0 +1,334 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Queries the status of the most recent test runs for every host known to the
+# database.  This is roughly based on:
+#
+# SELECT machine_name.name, test_run.start_time, max(test_run.mtime),
+# test_run.kernel, test_run.mount_opts, test_run.mkfs_opts, test_run.run_time,
+# test_run.failed, test_run.skipped, test_run.tried, test_run.counted from
+# test_run, machine_name where machine_name.id = test_run.machine_name_id group
+# by machine_name_id order by test_run.mtime;
+
+# Usage: $0 db_dir
+
+import sys
+import os
+import json
+import argparse
+import xml.etree.ElementTree as ET
+import email.utils as EU
+import datetime
+import subprocess
+
+sys.path.append('%pkg_lib_dir%')
+import fstestdb
+
+def die(s):
+	print(s)
+	sys.exit(1)
+
+DEBUG = 'DBG' in os.environ
+
+def now_timestamp():
+	x = datetime.datetime.now(datetime.UTC)
+	return x.timestamp()
+
+def render_testrun_failures(dq, testrun):
+	'''Render test failures as names or hashes.'''
+	return ', '.join([find_test_name(dq, x) for x in dq.query_failed_tests(testrun)])
+
+def find_test_name(dq, test):
+	'''Find the name of this test.'''
+	for testname in dq.query_test_name(test):
+		return testname.name
+	return f'{test.hash_id.value[:12]}...'
+
+def _human_pct(n, d):
+	'''Render a fraction as a human-readable percentage.'''
+	if n <= 0:
+		return '0%'
+	if d == 0:
+		d += 1
+	pct = 100.0 * n / d;
+	if pct >= 10:
+		return f'{pct:.0f}%'
+	if pct >= 1:
+		return f'{pct:.1f}%'
+	if pct >= 0.1:
+		return f'{pct:.2f}%'
+	return f'{pct:.3f}%'
+
+def _summary(testrun, nr):
+	'''Render numerical status.'''
+	status = f'{nr:,} of {testrun.attempted:,} '
+	status += f'({_human_pct(nr, testrun.attempted)}) tests'
+	if testrun.run_time is None:
+		status += ' so far';
+
+	# If we ran fewer than 100 tests then assume we weren't trying for a
+	# comprehensive QA run.  Coverage here is defined as tests that passed,
+	# failed, or weren't appropriate for the fs configuration (i.e.
+	# _notrun).
+	if testrun.attempted >= 100:
+		status += f', covering {_human_pct(testrun.tried, testrun.counted)} '
+		status += f'of {testrun.counted:,}'
+
+	# Estimate the amount of time elapsed so far.
+	if testrun.run_time is None:
+		elapsed = int(now_timestamp()) - testrun.start_time;
+		status += ' after ';
+	else:
+		elapsed = testrun.run_time;
+		status += ' in ';
+
+	if elapsed >= 86400:
+		status += f'{elapsed / 86400:.1f} days.'
+	elif elapsed >= 3600:
+		status += f'{elapsed / 3600:.1f} hours.'
+	elif elapsed >= 60:
+		status += f'{elapsed / 60:.0f} mins.'
+	else:
+		status += f'{elapsed:.0f} secs.'
+	return status
+
+def render_status(testrun):
+	'''Render status message.'''
+	def st(color, status):
+		'''Render status line'''
+		return f'<span style="color: {color}; font-weight: bold">{status}</span>'
+
+	# From the junit xml reports, we have some summary counters:
+	#  - failed/failures: # of real test failures;
+	#  - tried/tests: # of tests we chose for this test run;
+	#  - skipped: # of tests that declined to run;
+	#  - counted: # of tests in the fingerprint file.
+	#
+	# # of tests attempted so far is (tried - skipped).
+	# # of tests that passed so far is (attempted - failed).
+
+	testrun.attempted = testrun.tried - testrun.skipped
+	testrun.passed = testrun.attempted - testrun.failed
+	testrun.notsel = testrun.counted - testrun.tried
+
+	# Still running...
+	if testrun.run_time is None:
+		is_late = testrun.mtime < now_timestamp() - (15 * 60)
+		if is_late:
+			s = st('blue', 'Running Late')
+		else:
+			s = st('black', 'Running')
+		return s + ', passed ' + _summary(testrun, testrun.passed)
+
+	# Finished without running anything.
+	if testrun.attempted < 1:
+		return 'Did not run any tests.'
+
+	# Finished with failures.
+	if testrun.failed > 0:
+		return st('red', 'Failed') + ' ' +  _summary(testrun, testrun.failed)
+
+	# Everything passed!
+	return st('#00c000', 'Passed') + ' all ' + _summary(testrun, testrun.passed)
+
+def dump_rss(runs, fails, dq, fd, urlprefix):
+	'''Print the query results as RSS.'''
+	def fs(s):
+		return s.replace(',', ', ')
+
+	rss_elt = ET.Element('rss')
+	rss_elt.attrib['version'] = '2.0'
+	channel_elt = ET.SubElement(rss_elt, 'channel')
+
+	title_elt = ET.SubElement(channel_elt, 'title')
+	title_elt.text = 'fstests'
+
+	pubdate_elt = ET.SubElement(channel_elt, 'pubDate')
+	pubdate_elt.text = EU.formatdate(int(now_timestamp()))
+
+	descr_elt = ET.SubElement(channel_elt, 'description')
+	descr_elt.text = 'Recent runs of the fstests suite.'
+
+	link_elt = ET.SubElement(channel_elt, 'link')
+	link_elt.text = 'https://kernel.org/'
+
+	lang_elt = ET.SubElement(channel_elt, 'language')
+	lang_elt.text = 'en-US'
+
+	for testrun in runs:
+		# Only finished runs
+		if testrun.run_time is None:
+			continue
+		item_elt = ET.SubElement(channel_elt, 'item')
+
+		title_elt = ET.SubElement(item_elt, 'title')
+		title_elt.text = f'Test Run on {testrun.machine_name_id.name}'
+
+		link_elt = ET.SubElement(item_elt, 'link')
+		link_elt.text = f'{urlprefix}output/.{testrun.machine_id.hash_id.value}/.{testrun.hash_id.value}/?C=M;O=A'
+
+		guid_elt = ET.SubElement(item_elt, 'guid')
+		guid_elt.attrib['isPermaLink'] = 'false'
+		guid_elt.text = f'betaA_{testrun.hash_id.value}'
+
+		descr = '<table><tbody>'
+		right_td = '<tr><td style="white-space: nowrap; text-align: right; vertical-align: top; padding-right: 0.5em;">'
+		# Older versions of the reporter didn't consistently capture
+		# these datapoints, with the exception of FSTYP.
+		if testrun.kernel is not None:
+			descr += f'{right_td}Kernel:</td><td>{testrun.kernel}</td></tr>'
+		if testrun.mkfs_opts is not None:
+			descr += f'{right_td}Format:</td><td>mkfs.{testrun.fstyp} {fs(testrun.mkfs_opts)}</td></tr>'
+		if testrun.mount_opts is not None:
+			descr += f'{right_td}Mount:</td><td>{fs(testrun.mount_opts)}</td></tr>'
+		if testrun.check_opts is not None:
+			descr += f'{right_td}Testing:</td><td>{fs(testrun.check_opts)}</td></tr>'
+		if testrun.failed > 0:
+			descr += f'{right_td}Failures:</td><td>{fails[testrun]}</td></tr>'
+		descr += f'{right_td}Status:</td><td>{render_status(testrun)}</td></tr>'
+		descr += '</tbody></table>'
+
+		descr_elt = ET.SubElement(item_elt, 'description')
+		descr_elt.text = descr
+
+		pubdate_elt = ET.SubElement(item_elt, 'pubDate')
+		pubdate_elt.text = EU.formatdate(testrun.mtime)
+
+	xml = ET.ElementTree(rss_elt)
+	ET.indent(xml, space = '\t')
+	xml.write(fd, encoding = 'unicode', xml_declaration = True)
+
+def dump_json(runs, fails, dq, fd):
+	'''Dump the test run results as JSON.'''
+	results = []
+	for testrun in runs:
+		hostname = testrun.machine_name_id.name
+		result = {}
+		result['name'] = hostname
+		result['kernel'] = testrun.kernel
+		result['fstyp'] = testrun.fstyp
+		result['mkfs_opts'] = testrun.mkfs_opts
+		result['mount_opts'] = testrun.mount_opts
+		result['time'] = testrun.mtime
+		result['testing'] = testrun.check_opts
+		if testrun.failed > 0:
+			result['failures'] = fails[testrun]
+
+		# New stuff
+		result['start_time'] = testrun.start_time
+		result['failed'] = testrun.failed
+		result['skipped'] = testrun.skipped
+		result['tried'] = testrun.tried
+		result['counted'] = testrun.counted
+		result['run_time'] = testrun.run_time
+
+		# Link to the actual test results
+		result['machine_hash'] = testrun.machine_id.hash_id.value
+		result['test_run_hash'] = testrun.hash_id.value
+
+		results.append(result)
+
+	json.dump(results, fd, indent = 4)
+
+def check_args(args):
+	if args.urlprefix == '':
+		print('urlprefix cannot be an empty string.')
+		sys.exit(1)
+	if args.rss is not None and args.urlprefix is None:
+		print('urlprefix must be specified.')
+		sys.exit(1)
+
+def run(args):
+	'''Return a subprocess, having opened stdin as a pipe.'''
+	p = subprocess.Popen(args)
+	p.wait()
+	if p.returncode != 0:
+		raise subprocess.CalledProcessError(p.returncode, args)
+
+def generate(dq, runs, args):
+	files = []
+	fails = {}
+	for testrun in runs:
+		if testrun.failed > 0:
+			fails[testrun] = render_testrun_failures(dq, testrun)
+
+	if args.json is not None:
+		with open(args.json, 'w') as fd:
+			dump_json(runs, fails, dq, fd)
+			files.append(args.json)
+
+	if args.rss is not None:
+		with open(args.rss, 'w') as fd:
+			dump_rss(runs, fails, dq, fd, args.urlprefix)
+			files.append(args.rss)
+
+	if args.rss is None and args.json is None:
+		dump_json(runs, fails, dq, sys.stdout)
+
+	if args.compress:
+		cmd = ['brotli', '-9', '-f', '--rm'] + files
+		run(cmd)
+
+def recent_main():
+	p = argparse.ArgumentParser(
+			description = 'Query most recent test runs for each host.')
+	p.add_argument('db_dir', type = str,
+			help = 'Directory containing database.')
+	p.add_argument('--json', type = str,
+			help = 'Dump output to this file in JSON format.')
+	p.add_argument('--rss', type = str,
+			help = 'Dump output to this file in RSS format.')
+	p.add_argument('--urlprefix', type = str,
+			help = 'URL prefix of the output directory, for RSS.')
+	p.add_argument('--max-age', type = int,
+			help = 'Maximum age of test results to examine, in days.')
+	p.add_argument('--compress', action = 'store_true',
+			help = 'Compress the output files with brotli -9.')
+
+	args = p.parse_args()
+	check_args(args)
+
+	# Connect to the database
+	db = fstestdb.Database(args.db_dir, readonly = True)
+	dq = fstestdb.DatabaseQuery(db)
+	if args.max_age:
+		if args.max_age <= 0:
+			print('max age must be a positive integer.')
+			sys.exit(1)
+		ma = args.max_age * 86400
+	else:
+		ma = None
+	runs = list(dq.query_current_test_runs(max_age = ma))
+
+	generate(dq, runs, args)
+
+def all_main():
+	p = argparse.ArgumentParser(
+			description = 'Query all test runs for each host.')
+	p.add_argument('db_dir', type = str,
+			help = 'Directory containing database.')
+	p.add_argument('--json', type = str,
+			help = 'Dump output to this file in JSON format.')
+	p.add_argument('--rss', type = str,
+			help = 'Dump output to this file in RSS format.')
+	p.add_argument('--urlprefix', type = str,
+			help = 'URL prefix of the output directory, for RSS.')
+	p.add_argument('--compress', action = 'store_true',
+			help = 'Compress the output files with brotli -9.')
+
+	args = p.parse_args()
+	check_args(args)
+
+	# Connect to the database
+	db = fstestdb.Database(args.db_dir, readonly = True)
+	dq = fstestdb.DatabaseQuery(db)
+	runs = list(dq.query_test_runs())
+
+	generate(dq, runs, args)
+
+if __name__ == '__main__':
+	if 'query_recent_test_runs' in sys.argv[0]:
+		recent_main()
+	else:
+		all_main()
diff --git a/matrix/database/query_checktime b/matrix/database/query_checktime
new file mode 100755
index 00000000000000..34aa047d7c2c45
--- /dev/null
+++ b/matrix/database/query_checktime
@@ -0,0 +1,31 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Generate check.time file
+# Usage: $0 fsmatrix-dir machine-hash
+
+srcdir="$(dirname "$0")"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+if [ $# -ne 2 ] || [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Report on average test runtimes for a given machine type id."
+	echo "Usage: $0 database_dir machine_id"
+	exit 1
+fi
+
+fsmatrix="$1"
+machine_hash="$2"
+
+mkdir -p "${fsmatrix}"
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+test -n "${machine_hash}" || die "no machine hash"
+
+args=('-cmd' '.mode tabs')
+args+=('-cmd' "SELECT test_name, avg_runtime FROM check_time WHERE machine_hash = '${machine_hash}';")
+
+"${srcdir}/db" "${fsmatrix}" "${args[@]}" < /dev/null
diff --git a/matrix/database/query_machines.in b/matrix/database/query_machines.in
new file mode 100755
index 00000000000000..1e5beb76ab6c3d
--- /dev/null
+++ b/matrix/database/query_machines.in
@@ -0,0 +1,41 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Query database for test machine information.
+# Usage; $0 ...
+
+import sys
+import argparse
+import traceback
+
+sys.path.append('%pkg_lib_dir%')
+import fstestdb
+
+def main():
+	t = fstestdb.MachineWithName
+	p = argparse.ArgumentParser(
+			description = 'Query database for test run IDs.')
+	p.add_argument('db_dir', type = str,
+			help = 'Directory containing database.')
+	p.add_argument('--attrs', type = str,
+			help = 'Attributes to return.')
+	p.add_argument('query', type = str,
+			help = 'Query to run.')
+	args = p.parse_args()
+
+	db = fstestdb.Database(args.db_dir)
+	q = fstestdb.DatabaseQuery(db)
+	n = fstestdb.DatabaseQuery.construct_ns_map(t)
+	kwargs = {}
+	if args.attrs is not None:
+		a = fstestdb.DatabaseQuery.interpret_attrs(args.attrs, n)
+		kwargs['attrs'] = a
+		print(a)
+	p = fstestdb.DatabaseQuery.interpret_predicates(args.query, n)
+
+	for r in q.query_single_table(t, p, **kwargs):
+		print(r.__dict__)
+
+if __name__ == '__main__':
+	main()
diff --git a/matrix/database/query_test_run.in b/matrix/database/query_test_run.in
new file mode 100755
index 00000000000000..a6474edf4b7c7e
--- /dev/null
+++ b/matrix/database/query_test_run.in
@@ -0,0 +1,38 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Query database for test run ids.
+
+import sys
+import argparse
+
+sys.path.append('%pkg_lib_dir%')
+import fstestdb
+
+
+def die(s):
+	print(s)
+	sys.exit(1)
+
+def main():
+	p = argparse.ArgumentParser(
+			description = 'Query database for test run IDs.')
+	p.add_argument('db_dir', type = str,
+			help = 'Directory containing database.')
+	p.add_argument('--name', type = str,
+			help = 'Name of test machine.')
+	p.add_argument('--or', type = bool,
+			help = 'sgasdg')
+	args = p.parse_args()
+
+	db = fstestdb.Database(args.db_dir)
+	q = fstestdb.DatabaseQuery(db)
+
+	if args.name is not None:
+		for r in q.query_test_runs_by_machine_name(args.name,
+				exact = '%' not in args.name):
+			print(r.__dict__)
+
+if __name__ == '__main__':
+	main()
diff --git a/matrix/database/stow_tarball b/matrix/database/stow_tarball
new file mode 100755
index 00000000000000..f6226d954834b5
--- /dev/null
+++ b/matrix/database/stow_tarball
@@ -0,0 +1,169 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Unpack fstests results tarball
+# Usage: $0 fsmatrix-dir tarball
+
+srcdir="$(readlink -m "$(dirname "$0")")"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+if [ $# -ne 2 ] || [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Unpack a test results tarball and absorb it into the database."
+	echo "Usage: $0 database_dir tarball"
+	exit 1
+fi
+
+fsmatrix="$1"
+tarball="$2"
+
+mkdir -p "${fsmatrix}"
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+test -f "${tarball}" || die "tarball not present"
+
+fsmatrix="$(readlink -m "${fsmatrix}")"
+tarball="$(readlink -m "${tarball}")"
+fingerprints_dir="${fsmatrix}/fingerprints"
+groups_dir="${fsmatrix}/groups"
+machines_dir="${fsmatrix}/machines"
+tmpdir="${fsmatrix}/tmp/incoming.$$"
+
+trap 'rm -r -f "${tmpdir}"' INT TERM QUIT EXIT
+rm -rf "${tmpdir}"
+mkdir -p "${tmpdir}" "${groups_dir}" "${fingerprints_dir}" "${machines_dir}"
+
+cd "${tmpdir}"
+tar xf "${tarball}"
+chmod -R a+r .
+find results/ -type f -size +262144 | while read bigfile; do
+	truncate -s 262144 "${bigfile}"
+done
+
+test -e summary/result.xml || die "result.xml: not found"
+
+mkid() {
+	sha256sum - | awk '{print $1}'
+}
+
+machine_id="$(mkid < machine/fingerprint)"
+machine_dir="${machines_dir}/.${machine_id}"
+machine_hostname="$(tr './' '__' < machine/hostname)"
+test -z "${machine_hostname}" && machine_hostname="unknown"
+
+# Extract the start time of the test run.  We cannot use the timestamp in the
+# xunit report because that reflects when the report file was generated.
+# If the start time is invalid, use 1/1/1980
+testrun_starttime="$(cat summary/check.starttime)"
+date --date=@"${testrun_starttime}" &>/dev/null || testrun_starttime=315532800
+
+# Unpack machine profile and add it to the database
+if [ ! -d "${machine_dir}" ]; then
+	mkdir -p "${machine_dir}"
+	cp -p -R -u -t "${machine_dir}" machine/*
+fi
+
+# Update the machine name symlink so that it points to the most recently
+# processed results.  (Note that most recently processed is /probably/ also the
+# most up to date, but the caller must stow tarballs in the order that they are
+# generated.)  We expect machine configs to change, so the pretty name points
+# to the fugly machine readable name here.
+(cd "${machines_dir}" ; ln -s -f -n ".${machine_id}" "${machine_hostname}")
+
+testrun_start="$(TZ=UTC date --date="@${testrun_starttime}" +'%Y-%m-%d_%H-%M-%S')"
+testrun_name="${machine_hostname}_${testrun_start}"
+testrun_id="$( (echo "${testrun_name}"; cat summary/test-fingerprints) | mkid)"
+testrun_dir="${machine_dir}/${testrun_name}"
+
+# Unpack the test run data and add that to the database
+mkdir -p "${testrun_dir}"
+cp -p -R -u -t "${testrun_dir}" summary/*
+
+# Deduplicate a (read-only) file.  The second parameter should be a directory
+# with a bunch of files whose names are the hash of their contents.  Generate a
+# content hash for the file; if there's a match in the hash directory, symlink
+# the file to the hash-file.  Otherwise leave it alone.
+try_dedupe() {
+	local file="$1"
+	local dedupe_dir="$2"
+
+	test -e "${file}" || return 0
+	test -d "${dedupe_dir}" || return 0
+
+	local file_id="$(mkid < "${file}")"
+	local dedupe_file="${dedupe_dir}/${file_id}"
+
+	if [ -e "${dedupe_file}" ]; then
+		# hashes match but contents do not; leave it alone
+		cmp -s "${dedupe_file}" "${file}" || return 1
+	else
+		# copy the file to the dedupe dir
+		cp -p "${file}" "${dedupe_file}"
+	fi
+
+	# symlink the original file to the hash-file in the dedupe-dir
+	local tgt="$(realpath --relative-to="$(dirname "${file}")" "${dedupe_file}")"
+	ln -s -f "${tgt}" "${file}"
+}
+
+# Try to dedupe the fingerprint and group files
+try_dedupe "${testrun_dir}/test-fingerprints" "${fingerprints_dir}"
+try_dedupe "${testrun_dir}/test-groups" "${groups_dir}"
+
+# Create a fugly machine readable symlink for the test run.  The pretty test
+# run name should be unique (since it encodes hostname and date) so we make
+# the fugly name point to the pretty one.
+(cd "${machine_dir}" ; rm -f ".${testrun_id}" ; ln -s -f -n "${testrun_name}" ".${testrun_id}")
+
+# Unpack the test statistics and add that to the database, if they exist
+if cd stats &>/dev/null; then
+	find . -type f | while read file; do
+		seq="$(echo "${file}" | sed -e 's/^..\([0-9a-zA-Z]*\/[0-9a-zA-Z-]*\).*$/\1/g')"
+		flat_seq="$(echo "${seq}" | tr '/' '_')"
+		test_id="$(grep "${seq}[[:space:]]" "${testrun_dir}/test-fingerprints" | awk '{print $2}')"
+
+		new_file="$(echo "${file}" | sed -e "s|^.\/|${testrun_dir}/stats/|g" -e "s|${seq}|${flat_seq}|g")"
+		mkdir -p "$(dirname "${new_file}")"
+		cp -p -u "${file}" "${new_file}"
+
+		# Create a fugly machine readable symlink since the name used in the
+		# output file reflects the test name at that particular point in time.
+		link_tgt="$(basename "${new_file}")"
+		link="$(echo "${link_tgt}" | sed -e "s|${flat_seq}|.${test_id}|g")"
+		mkdir -p "${testrun_dir}/stats/"
+		(cd "${testrun_dir}/stats/" ; rm -f "${link}" ; ln -s -f -n "${link_tgt}" "${link}")
+	done
+	cd ..
+fi
+
+# Unpack the test results and add that to the database
+cd results
+find . -type f | while read file; do
+	seq="$(echo "${file}" | sed -e 's/^..\([0-9a-zA-Z]*\/[0-9a-zA-Z-]*\).*$/\1/g')"
+	flat_seq="$(echo "${seq}" | tr '/' '_')"
+	test_id="$(grep "${seq}[[:space:]]" "${testrun_dir}/test-fingerprints" | awk '{print $2}')"
+
+	# If this isn't a test result file (e.g. console.txt) then all we need
+	# to do is preserve the file and move on.  No fugly symlinks.
+	if [ -z "${test_id}" ]; then
+		new_file="$(echo "${file}" | sed -e "s|^.\/|${testrun_dir}/|g")"
+		cp -p -u "${file}" "${new_file}"
+		continue
+	fi
+
+	# Otherwise copy the file to the output dir with the slashes flattened
+	# to underscores.
+	new_file="$(echo "${file}" | sed -e "s|^.\/|${testrun_dir}/|g" -e "s|${seq}|${flat_seq}|g")"
+	cp -p -u "${file}" "${new_file}"
+
+	# Create a fugly machine readable symlink since the name used in the
+	# output file reflects the test name at that particular point in time.
+	link_tgt="$(basename "${new_file}")"
+	link="$(echo "${link_tgt}" | sed -e "s|${flat_seq}|.${test_id}|g")"
+	(cd "${testrun_dir}" ; rm -f "${link}" ; ln -s -f -n "${link_tgt}" "${link}")
+done
+
+"${srcdir}/upsert_test_run" "${fsmatrix}" "${tmpdir}/summary/" "${tmpdir}/machine/" "${testrun_dir}/" "${machine_id}" "${testrun_id}"
diff --git a/matrix/database/stow_tarballs b/matrix/database/stow_tarballs
new file mode 100755
index 00000000000000..ab224e57e755cc
--- /dev/null
+++ b/matrix/database/stow_tarballs
@@ -0,0 +1,34 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Unpack fstests results tarballs
+# Usage: $0 fsmatrix-dir tarball-dir
+
+srcdir="$(readlink -m "$(dirname "$0")")"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+if [ $# -ne 2 ] || [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Unpack recently modified test result tarballs in a directory and absorb them into the database."
+	echo "Usage: $0 database_dir tarball_dir"
+	exit 1
+fi
+
+fsmatrix="$1"
+tarballs="$2"
+
+mkdir -p "${fsmatrix}"
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+test -d "${tarballs}" || die "tarball dir not present"
+
+cd "${tarballs}"
+"${srcdir}/find_new_tarballs" "${tarballs}/" | \
+	awk -F '|' '{print $2}' | \
+	xargs -P 2 -n 1 -r -t "${srcdir}/stow_tarball" "${fsmatrix}"
+
+test -n "${DBG}" && symlinks -r -d "${fsmatrix}"
+exit 0
diff --git a/matrix/database/test_runtime b/matrix/database/test_runtime
new file mode 100755
index 00000000000000..349a57091a241b
--- /dev/null
+++ b/matrix/database/test_runtime
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Turn a result.xml into a simple report of test name and runtime
+
+grep time= result.xml | \
+	sed -e 's/^.*name..//g' -e 's/..time../ /g' -e 's/..$//g' | \
+	awk '{printf("%-16s%u\n", $1, $2);}' | \
+	sort -g -k 2
diff --git a/matrix/database/upsert_test_run.in b/matrix/database/upsert_test_run.in
new file mode 100755
index 00000000000000..b578d33f689366
--- /dev/null
+++ b/matrix/database/upsert_test_run.in
@@ -0,0 +1,448 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Upsert the details of a test run to the database
+# Usage: $0 db_dir summary_dir machine_dir result_dir machine_id testrun_id
+
+import sys
+import json
+import sqlite3
+import os
+import argparse
+import xml.etree.ElementTree as ET
+
+sys.path.append('%pkg_lib_dir%')
+import fstestdb
+
+def die(s):
+	print(s)
+	sys.exit(1)
+
+DEBUG = 'DBG' in os.environ
+
+def cvtnum(s):
+	def suffix(s):
+		for x in range(len(s) - 1, -1, -1):
+			if s[x].isdigit():
+				return x + 1
+	x = suffix(s)
+	number = float(s[:x])
+	unit = s[x:].strip().casefold()
+	if unit.startswith('p'):
+		number *= (1 << 50)
+	elif unit.startswith('t'):
+		number *= (1 << 40)
+	elif unit.startswith('g'):
+		number *= (1 << 30)
+	elif unit.startswith('m'):
+		number *= (1 << 20)
+	elif unit.startswith('k'):
+		number *= (1 << 10)
+	return number
+
+def cvtnum_mb(s):
+	return int(cvtnum(s) / 1048576)
+
+def testrun_starttime(summary_dir):
+	'''Return the start time of a test run as the number of seconds since
+	the start of the Unix epoch, 1/1/1970 00:00:00 UTC'''
+
+	fname = f'{summary_dir}/check.starttime'
+	with open(fname, mode = 'r', encoding = 'utf-8') as fd:
+		for line in fd:
+			return int(line)
+
+def report_mtime(summary_dir):
+	'''Return the time when the fstests report was last generated, in
+	seconds since 1/1/1970 00:00:00 UTC.'''
+
+	files = ['result.xml', 'check.report', 'check.log', 'check.time']
+	for f in files:
+		try:
+			return int(os.stat(f'{summary_dir}/{f}').st_mtime)
+		except:
+			continue
+	return None
+
+def parse_test_mappings(fp_fd):
+	'''Map a test's short name (e.g. generic/388) to its hash.'''
+	mappings = {}
+
+	for line in fp_fd:
+		x = line.split()
+		if len(x) != 2:
+			x = line.split(',')
+		short_name = x[0].strip()
+		test_hash = x[1].strip()
+		mappings[short_name] = test_hash
+
+	return mappings
+
+def parse_machine_fingerprint(machine, fp_fd, blk_fd):
+	'''Load machine fingerprint info into the machine object.'''
+	xlate = {
+		'Architecture:'.casefold():	('arch', lambda x: x),
+		'CPU(s):'.casefold():		('cpus', int),
+		'NUMA node(s):'.casefold():	('nodes', int),
+		'MemTotal:'.casefold():		('ram_mb', cvtnum_mb),
+	}
+
+	for line in fp_fd:
+		cfline = line.strip().casefold()
+		line_used = False
+		for x in xlate:
+			if cfline.startswith(x):
+				v = cfline[len(x):].strip()
+				machine.set_attr(xlate[x][0], xlate[x][1](v))
+				line_used = True
+				break
+		if line_used:
+			continue
+		if cfline.startswith('sd') or cfline.startswith('nvme'):
+			machine.add_disk(cvtnum_mb(cfline.split()[1]))
+		elif cfline.startswith('pmem'):
+			machine.add_pmem(cvtnum_mb(cfline.split()[1]))
+	if machine.arch is None:
+		raise Exception('not a machine fingerprint file')
+
+	try:
+		bdevs = json.load(blk_fd)['blockdevices']
+		machine.reset_storage()
+
+		for bdev in bdevs:
+			if 'children' in bdev:
+				del bdev['children']
+			if bdev['name'].startswith('pmem'):
+				machine.add_pmem(cvtnum_mb(bdev['size']))
+			else:
+				machine.add_disk(cvtnum_mb(bdev['size']))
+	except:
+		pass
+
+	machine.summarize_storage()
+
+def parse_summary(testrun, testsuite, summary_dir):
+	'''Load test run information from the summary data in the xunit report.'''
+	env = set(['SECTION', 'FSTYP', 'MKFS_OPTIONS', 'CHECK_OPTIONS',
+		   'TIME_FACTOR', 'LOAD_FACTOR', 'TEST_DIR', 'TEST_DEV',
+		   'SCRATCH_DEV', 'SCRATCH_MNT', 'MOUNT_OPTIONS',
+		   'KERNEL'])
+	vconvert = {
+		'SECTION': lambda x: None if x == '-no-sections-' else x,
+		'TIME_FACTOR': int,
+		'LOAD_FACTOR': int,
+	}
+	nconvert = {
+		'MKFS_OPTIONS': 'mkfs_opts',
+		'CHECK_OPTIONS': 'check_opts',
+		'MOUNT_OPTIONS': 'mount_opts',
+	}
+
+	# Compute the summary values from the xml structures because the
+	# values attached to the root node are known to be buggy; the @tests
+	# attribute is overstated by the number of @skipped tests.
+	testrun.set_attr('failed', len(testsuite.findall('./{*}testcase/{*}failure')))
+	testrun.set_attr('skipped', len(testsuite.findall('./{*}testcase/{*}skipped')))
+	testrun.set_attr('tried', len(testsuite.findall('./{*}testcase')))
+	if testsuite.attrib['time'] == '':
+		testrun.set_attr('run_time', None)
+	else:
+		testrun.set_attr('run_time', int(testsuite.attrib['time']))
+
+	for p in testsuite.findall('./{*}properties/{*}property'):
+		key = p.attrib['name']
+		val = p.attrib['value']
+		if key not in env:
+			continue
+
+		if key in vconvert:
+			val = vconvert[key](val)
+		if key in nconvert:
+			key = nconvert[key]
+		else:
+			key = key.lower()
+		testrun.set_attr(key, val)
+
+def parse_test_groups(group_fd):
+	'''Map a test (by short name) to all of its test groups (e.g. swapext, quota, rw, auto).'''
+	groups = {}
+
+	for line in group_fd:
+		comment = line.find('#')
+		if comment >= 0:
+			line = line[:comment]
+		x = [x.strip() for x in line.split()]
+		groups[x[0]] = x[1:]
+
+	return groups
+
+def compute_suffix_files():
+	ret = {
+		'diff':  ['.out.diff'],
+		'full':  ['.full'],
+		'dmesg': ['.dmesg']
+	}
+
+	for suffix in ret:
+		s = ret[suffix]
+		suffix = s[0]
+		for ext in ['gz', 'bz2', 'lz4', 'xz', 'zst', 'br']:
+			s.append(f'{suffix}.{ext}')
+	return ret
+
+def parse_test_results(db, new_results_dir, testrun, testmap, lastmod, testsuite):
+	'''Parse the results of a test.'''
+
+	suffix_files = compute_suffix_files()
+	for testcase in testsuite.findall('./{*}testcase'):
+		# Unpack xml
+		name = testcase.attrib['name']
+		if testcase.findall('./{*}failure'):
+			result = 'fail'
+		elif testcase.findall('./{*}skipped'):
+			result = 'notrun'
+		else:
+			result = 'pass'
+		test_time = testcase.attrib['time']
+
+		# Some tests fail to fingerprint (generic/257) so we ignore
+		# them.
+		if name not in testmap:
+			continue
+
+		# Result type we know about?
+		result_type = fstestdb.ResultType.resurrect(db, name = result)
+		if result_type.needs_update(lastmod):
+			result_type.touch(lastmod)
+			result_type.persist(db)
+
+		# Ensure the hash table has an entry for this test
+		testhash = fstestdb.Hash.resurrect(db, value = testmap[name])
+		if testhash.needs_update(lastmod):
+			testhash.touch(lastmod)
+			testhash.persist(db)
+
+		# Go find the test
+		test = fstestdb.Test.resurrect(db, hash_id = testhash)
+		if test.needs_update(lastmod):
+			test.set_relation('hash_id', testhash)
+			test.touch(lastmod)
+			test.persist(db)
+
+		# Now find the test result
+		result = fstestdb.Result.resurrect(db, test_run_id = testrun, \
+				test_id = test)
+
+		result.set_relation('result_type_id', result_type)
+		result.set_attr('runtime', int(test_time))
+		result.touch(lastmod)
+
+		# Figure out if we have artifacts from failed tests
+		suffix_stem = new_results_dir + '/' + name.replace('/', '_')
+		for suffix in suffix_files:
+			if result != 'fail':
+				result.set_attr(f'has_{suffix}', False)
+				continue
+
+			has_artifact = False
+			for ext in suffix_files[suffix]:
+				if os.path.isfile(f'{suffix_stem}{ext}'):
+					has_artifact = True
+					break
+			if DEBUG:
+				print((outfile, has_artifact))
+			result.set_attr(f'has_{suffix}', has_artifact)
+
+		if DEBUG:
+			print(result.__dict__)
+		result.persist(db)
+
+def main():
+	p = argparse.ArgumentParser(
+			description = 'Upsert test run details to database.')
+	p.add_argument('db_dir', type = str,
+			help = 'Directory containing database.')
+	p.add_argument('summary_dir', type = str,
+			help = 'Directory containing unpacked test results tarball.')
+	p.add_argument('machine_dir', type = str,
+			help = 'Directory containing test machine configuration.')
+	p.add_argument('result_dir', type = str,
+			help = 'Directory containing preserved test results artifacts.')
+	p.add_argument('machine_id', type = str,
+			help = 'Barely readable hash of the test machine config.')
+	p.add_argument('testrun_id', type = str,
+			help = 'Barely readable hash of the test run config.')
+	args = p.parse_args()
+
+	assert os.path.isdir(args.summary_dir)
+	assert os.path.isdir(args.machine_dir)
+
+	# Read the junit xml report.  fstests didn't always assign a namespace
+	# in the xml document, so the xpath selectors must use a wildcard.
+	# AFAICT etree doesn't let us set a default ns if the file doesn't
+	# specify.
+	xml = ET.parse(f'{args.summary_dir}/result.xml')
+	testsuite = xml.getroot()
+	hostname = testsuite.attrib['hostname']
+
+	# Map test shortnames to fingerprints and test groups.
+	fingerprints = f'{args.summary_dir}/test-fingerprints'
+	with open(fingerprints, mode = 'r', encoding = 'utf-8') as fd:
+		testmap = parse_test_mappings(fd)
+
+	groups = f'{args.summary_dir}/test-groups'
+	testgroups = {}
+	try:
+		with open(groups, mode = 'r', encoding = 'utf-8') as fd:
+			testgroups = parse_test_groups(fd)
+	except FileNotFoundError:
+		# Early test tarballs didn't record group data
+		pass
+
+	# Convert the test -> groups info into group -> tests...
+	groups = {}
+	for test in testgroups:
+		for group in testgroups[test]:
+			if group not in groups:
+				groups[group] = set()
+			groups[group].add(test)
+
+	# Connect to the database
+	db = fstestdb.Database(args.db_dir, readonly = False)
+	starttime = testrun_starttime(args.summary_dir)
+
+	# The last mod time of test results is the greater of the start time
+	# and the mtime of the check.* files.
+	lastmod = report_mtime(args.summary_dir)
+	if lastmod is None or lastmod < starttime:
+		lastmod = starttime
+
+	# Ensure the hash table has an entry for this machine
+	machinehash = fstestdb.Hash.resurrect(db, value = args.machine_id)
+	if machinehash.needs_update(starttime):
+		db.try_begin_update()
+		machinehash.touch(starttime)
+		machinehash.persist(db)
+
+	# Do we need to update this machine's profile?
+	machine = fstestdb.Machine.resurrect(db, hash_id = machinehash)
+	machine_name = fstestdb.MachineName.resurrect(db, name = hostname)
+	if machine.needs_update(starttime) or \
+	   machine_name.needs_update(starttime):
+		db.try_begin_update()
+		fingerprint = f'{args.machine_dir}/fingerprint'
+		blkdev = f'{args.machine_dir}/blk'
+		with open(fingerprint, mode = 'r', encoding = 'utf-8') as fp_fd:
+			with open(blkdev, mode = 'r', encoding = 'utf-8') as blk_fd:
+				parse_machine_fingerprint(machine, fp_fd, blk_fd)
+
+		machine.set_relation('hash_id', machinehash)
+		machine_name.set_relation('machine_id', machine)
+		machine_name.touch(starttime)
+		machine.touch(starttime)
+		machine_name.persist(db)
+
+	# Ensure the hash table has an entry for this test run
+	testrunhash = fstestdb.Hash.resurrect(db, value = args.testrun_id)
+	if testrunhash.needs_update(starttime):
+		db.try_begin_update()
+		testrunhash.touch(starttime)
+		testrunhash.persist(db)
+
+	# Do we need to update this test run's profile?
+	testrun = fstestdb.TestRun.resurrect(db, hash_id = testrunhash)
+	new_testrun_data = testrun.needs_update(starttime)
+	new_results_data = testrun.needs_update(lastmod)
+
+	if not new_testrun_data and not new_results_data:
+		# No new results or testruns, so commit and exit
+		if db.dirty():
+			db.commit_update()
+		return
+
+	# Always update testrun data, since either the profile has changed or
+	# we have new results
+	db.try_begin_update()
+	testrun.set_relation('hash_id', testrunhash)
+	testrun.set_relation('machine_id', machine)
+	testrun.set_relation('machine_name_id', machine_name)
+	parse_summary(testrun, testsuite, args.summary_dir)
+	testrun.set_attr('start_time', starttime)
+	testrun.set_attr('counted', len(testmap))
+	testrun.touch(lastmod)
+	testrun.persist(db)
+
+	if DEBUG:
+		print(machine.__dict__)
+		print(machine_name.__dict__)
+		print(testrun.__dict__)
+		print(testmap)
+		print(testgroups)
+
+	# Persist test fingerprint and short name info to database, preserving
+	# the Test objects for adding results later
+	test_objs = {}
+	for name in testmap:
+		if DEBUG:
+			print(name, testmap[name])
+
+		# Ensure the hash table has an entry for this test
+		testhash = fstestdb.Hash.resurrect(db, value = testmap[name])
+		if testhash.needs_update(starttime):
+			testhash.touch(starttime)
+			testhash.persist(db)
+
+		# Go find the test info
+		test = fstestdb.Test.resurrect(db, hash_id = testhash)
+		test.set_relation('hash_id', testhash)
+		testname = fstestdb.TestName.resurrect(db, name = name)
+
+		test_objs[name] = test
+
+		# Update the test name mappings if they're old and we updated
+		# the test run profile
+		if new_testrun_data and (test.needs_update(starttime) or \
+					 testname.needs_update(starttime)):
+			testname.set_relation('test_id', test)
+			testname.touch(starttime)
+			test.touch(starttime)
+
+			testname.persist(db)
+
+	# Persist test group membership to database if we updated the test run
+	# profile
+	for groupname in groups if new_testrun_data else {}:
+		if DEBUG:
+			print(groupname, groups[groupname])
+
+		group = fstestdb.Group.resurrect(db, name = groupname)
+
+		# Update the group profile
+		if group.needs_update(starttime):
+			group.touch(starttime)
+			group.persist(db)
+
+		for testname in groups[groupname]:
+			if testname not in test_objs:
+				continue
+
+			test = test_objs[testname]
+			member = fstestdb.GroupMember.resurrect(db, \
+					group_id = group, test_id = test)
+
+			# Update the group <-> test mappings
+			if member.needs_update(starttime):
+				member.touch(starttime)
+				member.persist(db)
+
+	# Add test results if the results report has changed since the last
+	# update
+	if new_results_data:
+		parse_test_results(db, args.result_dir, testrun, testmap, \
+				lastmod, testsuite)
+
+	db.commit_update()
+
+if __name__ == '__main__':
+	main()
diff --git a/matrix/database/views.sql b/matrix/database/views.sql
new file mode 100644
index 00000000000000..7eb0f9b90eb93a
--- /dev/null
+++ b/matrix/database/views.sql
@@ -0,0 +1,89 @@
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * Copyright (C) 2019-2026 Oracle.
+ *
+ * Main database schema for fstests results.
+ */
+DROP VIEW IF EXISTS avg_test_runtime;
+DROP VIEW IF EXISTS avg_test_machine_runtime;
+DROP VIEW IF EXISTS avg_test_kernel_runtime;
+DROP VIEW IF EXISTS check_time;
+DROP VIEW IF EXISTS machine_with_name;
+
+CREATE VIEW avg_test_runtime AS
+	SELECT
+		test_name.name AS test_name,
+		ROUND(AVG(result.runtime)) AS avg_runtime,
+		ROUND(STDEV(result.runtime)) AS stddev_runtime
+	FROM
+		test_name, result
+	WHERE
+		test_name.id = result.test_id
+	GROUP BY
+		test_name.name;
+
+CREATE VIEW check_time AS
+	SELECT
+		test_name.name AS test_name,
+		hash.value AS machine_hash,
+		CAST(AVG(result.runtime) AS INT) AS avg_runtime
+	FROM
+		test_name, result, machine, test_run, hash
+	WHERE
+		test_name.id = result.test_id AND
+		test_run.id = result.test_run_id AND
+		machine.id = test_run.machine_id AND
+		machine.hash_id = hash.id
+	GROUP BY
+		test_name.name, hash.id;
+
+CREATE VIEW avg_test_machine_runtime AS
+	SELECT
+		test_name.name AS test_name,
+		machine_name.name AS machine_name,
+		CAST(AVG(result.runtime) AS INT) AS avg_runtime,
+		CAST(STDEV(result.runtime) AS INT) AS stddev_runtime
+	FROM
+		test_name, result, machine, test_run, machine_name, hash
+	WHERE
+		test_name.id = result.test_id AND
+		test_run.id = result.test_run_id AND
+		machine.id = test_run.machine_id AND
+		machine_name.machine_id = machine.id AND
+		machine.hash_id = hash.id
+	GROUP BY
+		test_name.name, hash.id;
+
+CREATE VIEW avg_test_kernel_runtime AS
+	SELECT
+		test_name.name AS test_name,
+		test_run.kernel AS kernel,
+		CAST(AVG(result.runtime) AS INT) AS avg_runtime,
+		CAST(STDEV(result.runtime) AS INT) AS stddev_runtime
+	FROM
+		test_name, result, test_run
+	WHERE
+		test_name.id = result.test_id AND
+		test_run.id = result.test_run_id
+	GROUP BY
+		test_name.name, test_run.kernel;
+
+CREATE VIEW machine_with_name AS
+	SELECT
+		hash.value as hash,
+		machine.arch,
+		machine.ram_mb,
+		machine.cpus,
+		machine.nodes,
+		machine.nr_disk,
+		machine.disk_mb,
+		machine.nr_pmem,
+		machine.pmem_mb,
+		machine.mtime,
+		machine_name.name AS name,
+		machine_name.mtime AS name_mtime
+	FROM
+		machine, machine_name, hash
+	WHERE
+		machine.id = machine_name.machine_id AND
+		machine.hash_id = hash.id;

